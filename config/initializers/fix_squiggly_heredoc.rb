# https://github.com/ruby/ruby/commit/a43f2cbaa11c792cf417c6400d76710df77cd125
# Fix Ripper.lex error in dedenting squiggly heredoc
require 'ripper'
Ripper::Lexer.class_eval do
  def on_heredoc_dedent(v, w)
    @buf.last.each do |e|
      if e.event == :on_tstring_content
        if (n = dedent_string(e.tok, w)) > 0
          e.pos[1] += n
        end
      end
    end
    v
  end
end
