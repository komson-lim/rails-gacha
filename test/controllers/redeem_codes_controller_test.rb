require "test_helper"

class RedeemCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @redeem_code = redeem_codes(:one)
  end

  test "should get index" do
    get redeem_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_redeem_code_url
    assert_response :success
  end

  test "should create redeem_code" do
    assert_difference('RedeemCode.count') do
      post redeem_codes_url, params: { redeem_code: { amount: @redeem_code.amount, code: @redeem_code.code, status: @redeem_code.status } }
    end

    assert_redirected_to redeem_code_url(RedeemCode.last)
  end

  test "should show redeem_code" do
    get redeem_code_url(@redeem_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_redeem_code_url(@redeem_code)
    assert_response :success
  end

  test "should update redeem_code" do
    patch redeem_code_url(@redeem_code), params: { redeem_code: { amount: @redeem_code.amount, code: @redeem_code.code, status: @redeem_code.status } }
    assert_redirected_to redeem_code_url(@redeem_code)
  end

  test "should destroy redeem_code" do
    assert_difference('RedeemCode.count', -1) do
      delete redeem_code_url(@redeem_code)
    end

    assert_redirected_to redeem_codes_url
  end
end
