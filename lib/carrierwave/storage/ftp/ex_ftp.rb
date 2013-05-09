require 'net/ftp'

class ExFTP < Net::FTP
  def chmod(file, permissions)
    cmd = "CHMOD "+permissions + " " + file
    Rails.logger.info cmd
    site(cmd)
  end

  def mkdir_p(dir, permissions)
    parts = dir.split("/")
    if parts.first == "~"
      growing_path = ""
    else
      growing_path = "/"
    end
    for part in parts
      next if part == ""
      if growing_path == ""
        growing_path = part
      else
        growing_path = File.join(growing_path, part)
      end
      begin
        mkdir(growing_path)
        chdir(growing_path)
        chmod(growing_path, permissions)
      rescue Net::FTPPermError, Net::FTPTempError => e
      end
    end
  end
end
