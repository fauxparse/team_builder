class AutomaticallyFillAssignments
  attr_reader :occurrence, :save_results
  delegate :event, to: :occurrence

  def initialize(occurrence, save_results = true)
    @occurrence = occurrence
    @save_results = save_results
  end

  def call
    occurrence.transaction do
      members = occurrence.available_members.to_a
      allocations = event.allocations.includes(:role)[0..-1]

      while allocations.any? { |allocation| !filled?(allocation) }
        available = sorted_members_for_role(allocations.first.role)
        available.select! { |member| members.include? member }

        if available.empty?
          allocations.shift
        else
          member = available.shift
          occurrence.assignments.build(member: member, allocation: allocations.first)
          members.delete(member)
          allocations.rotate!
        end
      end

      occurrence.save! if save_results
    end
  end

  private

  def most_recent_assignments
    @most_recent_assignments ||= Assignment.most_recent_assignments_for(event)
      .where("occurrences.starts_at < ?", occurrence.starts_at)
  end

  def most_recent_assignment_for(member, role)
    most_recent_assignments.detect do |assignment|
      assignment.member_id == member.id && assignment.role_id == role.id
    end
  end

  def available_members
    @available_members ||= occurrence.availabilities
      .includes(:member)
      .map(&:member)
  end

  def sorted_members_for_role(role)
    @sorted_members ||= {}
    @sorted_members[role.id] ||= available_members
      .group_by { |member| most_recent_assignment_for(member, role).try(:starts_at) }
      .sort { |(a, _), (b, _)| compare_times(a, b) }
      .map { |_, members| members.shuffle }
      .flatten
  end

  def compare_times(a, b)
    if a.nil?
      -1
    elsif b.nil?
      1
    else
      a <=> b
    end
  end

  def filled?(allocation)
    return full if allocation.unlimited?
    occurrence.assignments.to_a
      .count { |assignment| assignment.allocation_id == allocation.id } >= allocation.maximum
  end
end
