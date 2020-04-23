module TempHelper
  def get_temp_dir
    Path.tmpdir.to_s
  end

  def remove_tmp_dir(dir)
    FileUtils.rm_rf dir
  end

  private

  include RandomizeHelper
  extend RandomizeHelper
end
