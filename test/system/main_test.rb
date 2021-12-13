require "application_system_test_case"

class MainTest < ApplicationSystemTestCase
    test "login success" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        assert_selector "h1", text: "Banner"
    end
    test "login fail" do
        visit "/main"
        fill_in "Username", with: "asdf"
        fill_in "Password", with: "asdf"
        click_on "Login"
        assert_selector "h1", text: "Login"
    end
    test "register" do
        visit "/register"
        fill_in "Username", with: "nnn"
        fill_in "Password", with: "nnn"
        fill_in "Confirm password", with: "nnn"
        click_on "Create User"
        assert_selector "h1", text: "Banner"
    end
    test "like banner" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        find('#banner-1').click_on("Like")
        visit "/favorite"
        assert has_css?('#banner-1')
    end
    test "unlike banner" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        find('#banner-1').click_on("Like")
        find('#banner-1').click_on("Unlike")
        visit "/favorite"
        assert !has_css?('#banner-1')
    end
    test "roll success" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/inventory"
        before_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        visit "/banner"
        find('#banner-1 > a').click
        before_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        find('#roll1').click
        assert_equal "You've got", find(".modal-title").text
        after_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        assert_equal 1, before_credit-after_credit
        visit "/inventory"
        after_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        assert_equal 1, after_entries - before_entries
    end
    test "roll fail not enough credit" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/banner"
        find('#banner-3 > a').click
        find('#roll1').click
        assert_equal "Failed to roll this banner", find("#modalTitle").text
        assert_equal "Reason: Not have enough credit", find("#roll-body").text
    end
    test "roll10 success" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/inventory"
        before_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        visit "/banner"
        find('#banner-1 > a').click
        before_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        find('#roll10').click
        assert_equal "You've got", find(".modal-title").text
        after_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        assert_equal 10, before_credit-after_credit
        visit "/inventory"
        after_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        assert_equal 10, after_entries - before_entries
    end
    test "roll10 fail not enough credit" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/banner"
        find('#banner-3 > a').click
        find('#roll10').click
        assert_equal "Failed to roll this banner", find("#modalTitle").text
        assert_equal "Reason: Not have enough credit", find("#roll-body").text
    end
    test "sell item success" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/market"
        before_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        visit "/inventory"
        find("#item-id-1").click_on("sell")
        fill_in "price", with: 5 
        find("#sellButton").click
        visit "/market"
        after_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        assert_equal 1, after_entries - before_entries
    end
    test "unsell success" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/inventory"
        find("#item-id-1").click_on("sell")
        fill_in "price", with: 5
        find("#sellButton").click
        visit "/inventory"
        find("#item-id-1").click_on("unsell")
        assert_equal "sell", find("#item-id-1 > form > input").value
    end
    test "buy item success" do
        visit "/main"
        fill_in "Username", with: "sss"
        fill_in "Password", with: "sss"
        click_on "Login"
        visit "/inventory"
        seller_before_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        seller_before_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/transaction"
        before_trans = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        visit "/market"
        before_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        before_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        price = find("#price-id-2").text.to_i
        find("#item-id-2").click_on("buy")
        after_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        assert_equal price, before_credit-after_credit
        after_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        assert_equal 1, before_entries - after_entries
        visit "/transaction"
        after_trans = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        assert_equal 1, after_trans - before_trans
        visit "/main"
        fill_in "Username", with: "sss"
        fill_in "Password", with: "sss"
        click_on "Login"
        visit "/inventory"
        seller_after_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        assert_equal price, seller_after_credit - seller_before_credit
        seller_after_entries = find('#inv_info').text.match(/(\d+) entries/i).captures[0].to_i
        assert_equal 1, seller_before_entries - seller_after_entries
    end
    test "buy item fail not enough credit" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/market"
        find("#item-id-3").click_on("buy")
        assert_equal "Not enough credit :(", find(".alert").text
    end
    test "redeem success" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/redeem"
        before_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        fill_in "code", with: "rrr"
        click_on "Submit"
        after_credit = find('#credit').text.match(/credit: (\d+)/i).captures[0].to_i
        assert_not_equal before_credit, after_credit
    end
    test "redeem fail" do
        visit "/main"
        fill_in "Username", with: "ddd"
        fill_in "Password", with: "ddd"
        click_on "Login"
        visit "/redeem"
        fill_in "code", with: "sadfsadf"
        click_on "Submit"
        assert_equal "Failed to redeem the code", find(".alert").text
    end
end
