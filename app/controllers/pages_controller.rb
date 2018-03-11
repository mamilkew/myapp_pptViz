class PagesController < ApplicationController
  def info
  end

  def home
  end

  def help
  end

  def convertcsv
    # require 'csv'
    # customers = CSV.read('civil.csv')
    # CSV.foreach('/civil.csv') do |row|
    #   puts row.inspect
    # end
    #

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

    lines = CSV.open(Rails.root + "/Users/milkk/Desktop/civil.csv").readlines
    # lines.shift # remove first entry of the lines array
    keys = lines.delete lines.first

    File.open("civil.json", "w") do |f|
      data = lines.map do |values|
        is_int(values) ? values.to_i : values.to_s
        Hash[keys.zip(values)]
      end

      def do_hash_children(array, key)
        return Hash[[:children].zip(array[key])]
      end

      # dep = ""
      # fos = ""
      modifier = []
      data.each do |values|
        # dep, fos, ra, kw1 = values.values_at('Department','FoS','Research Areas','Key words1')
        # ((modifier[dep] ||= {})[fos] ||= {})[ra] ||= kw1

        # modifier[dep][fos][ra] = kw1
        if !values['Department'].nil?
          modifier.push(Hash[[:name, :children].zip(
              [values['Department'], [Hash[[:name, :children].zip([values['FoS'], [Hash[[:name].zip([values['Research Areas']])]]])]]]
          )])
          # dep = values['Department']
          # fos = values['FoS']

        elsif !values['FoS'].nil? && !values['Research Areas'].nil?
          modifier[0][:children].push(
              Hash[[:name, :children].zip(
                  [values['FoS'], [Hash[[:name, :children].zip([values['Research Areas'], [Hash[[:name].zip([values['Key words1']])]]])]]]
              )]
          )


        end
      end

      f.puts JSON.pretty_generate(modifier)
      respond_to do |format|
        format.html { redirect_to pages_info_path, notice: 'Successfully.' }
      end
    end


  end
end
