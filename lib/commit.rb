class Commit < Struct.new(:data)
  def modified_file_paths
    data["added"] + data["modified"] + data["removed"]
  end

  def message
    data["message"]
  end
end
