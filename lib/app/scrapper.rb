require 'nokogiri'
require 'open-uri'
require 'json'

class Scrapper    
    
    def get_townhall_urls
        page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
        $city = page.xpath('//a[@class="lientxt"]').collect{|ville| ville.text.downcase.gsub(" ", "_") }
        #Sort le nom des villes en downcase avec un "_"
        return link_maire = page.xpath('//a[@class="lientxt"]').collect{|x| x['href']}.each{|x| x.slice!(0)}
        #Sort la fin du lien de chaque ville en "/95/wy-dit-joli-village.html"
    end

    def get_townhall_email(get_townhall_urls)
        link_city = get_townhall_urls.map{|p| "http://annuaire-des-mairies.com" + p}
        #Sort chaque lien de ville
        arr_mails = []
        result_mail = link_city.each{|link| arr_mails.push(Nokogiri::HTML(open(link)).css("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text)}
        hash = Hash[$city.zip(arr_mails)]
        puts hash
    end
        
    def save_as_JSON(hash)
        File.open("../../db/emails.json", "w") do 
        hash.each {|f|  f.write(hash.to_json)}
        end
        
    end

    def perform
        result = get_townhall_email(get_townhall_urls)
        save_as_JSON(result)
    end
end

Scrapper.new.perform