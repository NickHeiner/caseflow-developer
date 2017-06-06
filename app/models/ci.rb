class CI
  def initialize
    begin
      @caseflow = Travis::Repository.find('department-of-veterans-affairs/caseflow')
      
      # Cache the success rate while we are in the rescue block so all errors are caught.
      success_rate
    rescue => e
      @init_failed = true
    end
  end

  attr_reader :init_failed

  def success_rate
    unless @success_rate
      master_builds = @caseflow.each_build.select {|build| build.branch_info === 'master'}
      @success_rate ||= master_builds.select {|build| build.passed?}.count / master_builds.size.to_f
    end

    @success_rate
  end

  def success_category
    if @init_failed
      'init-failed'
    elsif success_rate >= 0.95
      'safe'
    elsif success_rate >= 0.7
      'flakey'
    else
      'dangerous'
    end
  end
end