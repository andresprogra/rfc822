module RFC822
  QTEXT = '[^\u000d\u0022\u005c\u0080-\u00ff]'
  DTEXT = '[^\u000d\u005b-\u005d\u0080-\u00ff]'
  ATOM = '[^\u0000-\u0020\u0022\u0028\u0029\u002c\u002e\u003a-\u003c\u003e\u0040\u005b-\u005d\u007f-\u00ff]+'
  QUOTED_PAIR = '\u005c[\u0000-\u007f]'
  DOMAIN_LITERAL = "\u005b(?:#{DTEXT}|#{QUOTED_PAIR})*\u005d"
  QUOTED_STRING = "\u0022(?:#{QTEXT}|#{QUOTED_PAIR})*\u0022"
  DOMAIN_REF = ATOM
  SUB_DOMAIN = "(?:#{DOMAIN_REF}|#{DOMAIN_LITERAL})"
  WORD = "(?:#{ATOM}|#{QUOTED_STRING})"
  DOMAIN = "#{SUB_DOMAIN}(?:\\x2e#{SUB_DOMAIN})*"
  LOCAL_PART = "#{WORD}(?:\\x2e#{WORD})*"
  ADDR_SPEC = "#{LOCAL_PART}\\x40#{DOMAIN}"

  EMAIL_REGEXP_WHOLE = /\A#{ADDR_SPEC}\z/i

  EMAIL_REGEXP_PART = /#{ADDR_SPEC}/i

end

class String
  def is_email?
    if RUBY_VERSION >= "1.9"
      (self.dup.force_encoding("BINARY") =~ RFC822::EMAIL_REGEXP_WHOLE) != nil
    else
      (self =~ RFC822::EMAIL_REGEXP_WHOLE) != nil
    end
  end

  def contains_email?
    if RUBY_VERSION >= "1.9"
      (self.dup.force_encoding("BINARY") =~ RFC822::EMAIL_REGEXP_PART) != nil
    else
      (self =~ RFC822::EMAIL_REGEXP_PART) != nil
    end
  end

  def scan_for_emails
    if RUBY_VERSION >= "1.9"
      self.dup.force_encoding("BINARY").scan(RFC822::EMAIL_REGEXP_PART)
    else
      self.scan(RFC822::EMAIL_REGEXP_PART)
    end
  end
end
