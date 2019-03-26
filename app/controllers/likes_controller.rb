class LikesController < ApplicationController
  def create
    @message = Message.find(params[:message_url_token])
    # @like = current_user.likes.create(message_id: params[:message_id])
    @like = Like.new(
      message_id: @message.id,
      user_id: current_user.id
    )
    if @like.save
      redirect_to user_message_path(current_user.nandeda_id, @message.url_token)
    else
      redirect_to controller: :messages, action: :index, notice: '失敗しました'
    end
  end

  def destroy
    @message = Message.find(params[:message_url_token])
    @like = Like.find_by(message_id: @message.id, user_id: current_user.id)
    @like.destroy
    redirect_to user_message_path(current_user.nandeda_id, @message.url_token)
  end

  private
  def like_params
    params.require(:like).permit(:message_id, :user_id)
  end
end
