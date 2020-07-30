class TasksController < ApplicationController
  before_action :require_user_logged_in

  def index
    @task = Task.all
  end
  
  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    #@task = Task.new(task_params)
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = '正常に投稿されました'
      redirect_to @task
    else
      #@tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = '投稿されませんでした'
      render :new
    end
    
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = '正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = '正常に削除されました'
    redirect_to tasks_url
  end

  private
  
  def task_params
      params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end