module Utility
  extend ActiveSupport::Concern

  def call_api
    response = RestClient.get ("https://test-users-2020.herokuapp.com/api/users"), {:Authorization => 'abc123'}
  end

  def format_phone phone
    phone_ele = phone.split('').map do |element|
      element if Integer(element) rescue nil
    end
    phone_ele.compact.insert(0,*["("]).insert(4,*[")"]).join(',').gsub(",", "")
  end

  def manipulate_response response
    data_hash =  {}
    response.each_with_index do |data, i|
      if data_hash.keys.include? "#{data["firstName"]} #{data["lastName"]}"
        data_hash_new = data_hash["#{data["firstName"]} #{data["lastName"]}"]
        data_hash_new.merge!(data["moreData"].except("phone"))
      else
        data_hash_new = {"firstName" => data["firstName"], "lastName" => data["lastName"], "email" => data["email"], "phone" => format_phone(data["moreData"]["phone"]), "moreData" => data["moreData"].except("phone")}
      end
      data_hash["#{data["firstName"]} #{data["lastName"]}"] = data_hash_new
    end


    final = data_hash.values.sort_by{|e| e["lastName"]}
    #putting copy in public
    File.open("public/transformed.json","w") do |f|
      f.write(final.to_json)
    end
    # check that can be read
    file = File.open "public/transformed.json"
    data = JSON.load file
  end
end
