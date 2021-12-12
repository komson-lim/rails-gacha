require "application_system_test_case"

class RedeemCodesTest < ApplicationSystemTestCase
  setup do
    @redeem_code = redeem_codes(:one)
  end

  test "visiting the index" do
    visit redeem_codes_url
    assert_selector "h1", text: "Redeem Codes"
  end

  test "creating a Redeem code" do
    visit redeem_codes_url
    click_on "New Redeem Code"

    fill_in "Amount", with: @redeem_code.amount
    fill_in "Code", with: @redeem_code.code
    fill_in "Status", with: @redeem_code.status
    click_on "Create Redeem code"

    assert_text "Redeem code was successfully created"
    click_on "Back"
  end

  test "updating a Redeem code" do
    visit redeem_codes_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @redeem_code.amount
    fill_in "Code", with: @redeem_code.code
    fill_in "Status", with: @redeem_code.status
    click_on "Update Redeem code"

    assert_text "Redeem code was successfully updated"
    click_on "Back"
  end

  test "destroying a Redeem code" do
    visit redeem_codes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Redeem code was successfully destroyed"
  end
end
