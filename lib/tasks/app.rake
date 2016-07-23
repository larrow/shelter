namespace :app do
  desc "generate key for registry and token server"
  task generate_key: :environment do
    if `which openssl` && $?.exitstatus == 0
      private_key_pem = File.join(Rails.root, 'config', 'private_key.pem')
      root_crt = File.join(Rails.root, 'config', 'registry', 'root.crt')
      File.delete private_key_pem if File.exists? private_key_pem
      File.delete root_crt if File.exists? root_crt

      `openssl genrsa -out #{private_key_pem} 4096`
      `openssl req -new -x509 -key #{private_key_pem} -out #{root_crt} -days 3650`
    else
      puts "Please install openssl first"
    end
  end

end
