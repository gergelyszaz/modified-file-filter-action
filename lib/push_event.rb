require_relative "commit"
require "json"

class PushEvent
  # https://developer.github.com/v3/activity/events/types/#pushevent
  REQUIRED_PUSH_EVENT_KEYS = %w(ref commits)

  attr_reader :data

  def initialize(raw_event)
    @data = JSON.parse(raw_event)
  end

  def valid?
    REQUIRED_PUSH_EVENT_KEYS.all? { |required_key| data.keys.include?(required_key) }
  end

  def modified?(file_path)
    modified_file_paths.include?(file_path)
  end

  private

  def modified_file_paths
    @modified_file_paths ||= commits.map(&:modified_file_paths).flatten.compact.uniq
  end

  def commits
    @commits ||= if data["commits"].nil?
      []
    else
      data["commits"].map { |commit_data| Commit.new(commit_data) }
    end
  end
end
