class SprintController < ApplicationController
	before_action :authenticate_user!

	def standup
		@in_progress_by_assignee = Github.new.in_progress_by_assignee
	end

	def backlog
		github = Github.new
		@current_sprint_issues = github.issues_by_label "Sprint 10/21"
		@last_sprint_issues = github.issues_by_label "Sprint 10/7"

		# Get Epics
		@current_issues_epics = []
		@current_sprint_issues.each do |issue|
			issue[:labels].each do |label|
				if label[:name].start_with? "epic-"
					@current_issues_epics << { name: label[:name] }
				end
			end
		end
	end
end
