# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# coding: utf-8

Category.create(:name => 'EPISODE', :slug =>'episode', :type =>'PostCategory')
Category.create(:name => 'COOKING', :slug =>'cooking', :type =>'PostCategory')
Category.create(:name => 'NEWS', :slug =>'information', :type =>'PostCategory')

Category.create(:name => 'お土産処', :slug =>'takeout', :type =>'ShopCategory')
Category.create(:name => 'お茶処', :slug =>'tea', :type =>'ShopCategory')
Category.create(:name => 'お食事処', :slug =>'meal', :type =>'ShopCategory')
Category.create(:name => 'オンライン', :slug =>'online', :type =>'ShopCategory')

Category.create(:name => '文化人', :slug =>'cultural_figures', :type =>'PersonCategory')
Category.create(:name => '文豪', :slug =>'literary_master', :type =>'PersonCategory')
Category.create(:name => '武将', :slug =>'military_commander', :type =>'PersonCategory')
Category.create(:name => '貴族', :slug =>'aristocracy', :type =>'PersonCategory')

Category.create(:name => 'TOUR', :slug =>'tour', :type =>'FeatureCategory')
Category.create(:name => 'PICKUP', :slug =>'event', :type =>'FeatureCategory')

Period.create(:name => '古墳以前')
Period.create(:name => '飛鳥')
Period.create(:name => '奈良')
Period.create(:name => '平安')
Period.create(:name => '鎌倉')
Period.create(:name => '南北朝')
Period.create(:name => '室町')
Period.create(:name => '戦国')
Period.create(:name => '安土桃山')
Period.create(:name => '江戸')
Period.create(:name => '明治')
Period.create(:name => '大正')
Period.create(:name => '昭和')

Price.create(:id => '1', :min => '0', :max => '999')
Price.create(:id => '2', :min => '1000', :max => '1999')
Price.create(:id => '3', :min => '2000', :max => '2999')
Price.create(:id => '4', :min => '3000', :max => '3999')
Price.create(:id => '5', :min => '4000', :max => '4999')
Price.create(:id => '6', :min => '5000', :max => '5999')
Price.create(:id => '7', :min => '6000', :max => '7999')
Price.create(:id => '8', :min => '8000', :max => '9999')
Price.create(:id => '9', :min => '10000', :max => '14999')
Price.create(:id => '10', :min => '15000', :max => '19999')
Price.create(:id => '11', :min => '20000', :max => '29999')
Price.create(:id => '12', :min => '30000', :max => '49999')
Price.create(:id => '13', :min => '50000', :max => '999999')
