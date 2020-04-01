require "stiction/version"

module Stiction
  # == Constants ============================================================
  
  # == Extensions ===========================================================

  # == Exceptions ===========================================================

  class Error < StandardError; end
  
  # == Properties ===========================================================
  
  # == Relationships ========================================================
  
  # == Validations ==========================================================
  
  # == Callbacks ============================================================
  
  # == Scopes ===============================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================

  def self.watch(stuck_threshold: 10.0, report_threshold: 1000.0, trace: false, &block)
    stuck_threshold /= 1000.0
    report_threshold /= 1000.0
    last_time = Time.now
    reactor_thread = Thread.current

    Async do |task|
      loop do
        last_time = Time.now
        task.sleep(stuck_threshold / 4)
      end
    end

    block ||= -> (drift) do
      $stderr.puts('Detected stiction (%.1fms)' % (drift * 1000))
    end

    Thread.new do
      tripped = false
      trip_start = nil
      report_at = nil

      loop do
        drift = Time.now - last_time

        if (drift > stuck_threshold)
          trip_start ||= last_time

          if (drift > report_threshold)
            if (!report_at or Time.now >= report_at)
              block.call(drift)

              if (trace)
                $stderr.puts("  " + reactor_thread.backtrace.join("\n  "))
              end

              report_at = Time.now + report_threshold
            end
          end

          tripped = true
        else
          if (trip_start)
            drift = Time.now - trip_start

            block.call(drift)

            if (trace)
              $stderr.puts("  " + reactor_thread.backtrace.join("\n  "))
            end
          end

          tripped = false
        end
      end
    end
  end
end
