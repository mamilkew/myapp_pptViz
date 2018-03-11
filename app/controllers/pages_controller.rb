class PagesController < ApplicationController
  def info
  end

  def home
  end

  def help
  end

  def convertcsv
    #!/usr/bin/env ruby

    # Parse CSV files and convert them to JSON.
    # Mostly used for preparing data for D3.js. I don't like using untyped
    # CSV files, so this script begins to clean things up for me.

    # Usage: ./parse.rb /path/to/input.csv /path/to/output.json

    require 'rubygems'
    require 'json'
    require 'csv'

    def is_int(str)
      # Check if a string should be an integer
      return !!(str =~ /^[-+]?[1-9]([0-9]*)?$/)
    end

#     lines = CSV.open(Rails.root + "/Users/milkk/Desktop/civil.csv",{:col_sep => "\|"}).readlines
# # remove first entry of the lines array
#     keys = lines.shift
  f_name = "multi"
    lines = CSV.open(Rails.root + "/Users/milkk/Desktop/#{f_name}.csv").readlines
    # lines.shift # remove first entry of the lines array
    keys = lines.delete lines.first

    File.open("public/assets/#{f_name}.json", "w") do |f|
      data = lines.map do |values|
        is_int(values) ? values.to_i : values.to_s
        Hash[keys.zip(values)]
      end

      count_fos = 0
      count_ra = 0
      modifier = []
      data.each do |values|
        if !values['Department'].nil?
          modifier.push(Hash[[:name, :children].zip(
              [values['Department'], [Hash[[:name, :children].zip([values['FoS'], [Hash[[:name, :children].zip([values['Research Areas'], [Hash[[:name].zip([values['Key words1']])]]])]]])]]]
          )])
          i = 2
          if !values['Key words2'].nil?
            values.each {|k, v|
              if k == 'Key words' + i.to_s && !v.nil?
                modifier[0][:children][count_fos][:children][count_ra][:children].push(
                    Hash[[:name].zip([v])
                    ])
                i += 1
              end
            }
          end

        elsif !values['FoS'].nil?
          modifier[0][:children].push(
              Hash[[:name, :children].zip(
                  [values['FoS'], [Hash[[:name, :children].zip([values['Research Areas'], [Hash[[:name].zip([values['Key words1']])]]])]]]
              )]
          )
          count_fos += 1
          count_ra = 0
          i = 2
          if !values['Key words2'].nil?
            values.each {|k, v|
              if k == 'Key words' + i.to_s && !v.nil?
                modifier[0][:children][count_fos][:children][count_ra][:children].push(
                    Hash[[:name].zip([v])
                    ])
                i += 1
              end
            }
          end

        elsif !values['Research Areas'].nil?
          modifier[0][:children][count_fos][:children].push(
              Hash[[:name, :children].zip(
                  [values['Research Areas'], [Hash[[:name].zip([values['Key words1']])]]]
              )]
          )
          count_ra += 1
          i = 2
          if !values['Key words2'].nil?
            values.each {|k, v|
              if k == 'Key words' + i.to_s && !v.nil?
                modifier[0][:children][count_fos][:children][count_ra][:children].push(
                    Hash[[:name].zip([v])
                    ])
                i += 1
              end
            }
          end
        end
      end

      f.puts JSON.pretty_generate(modifier[0])
      respond_to do |format|
        format.html { redirect_to pages_info_path, notice: 'Successfully.' }
      end
    end


  end
end
