class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_question,  only: [:show, :edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    if current_user && current_user.perfil.nil?
      redirect_to perfil_index_path
    end
    
    if params[:query].present?
      @questions = Question.search params[:query]
    else
      @questions = Question.all    
    end
  end


  # GET /questions/1
  # GET /questions/1.json
  def show
      @answers = Answer.where(question: @question)
      @answer = Answer.new()
  end

  # GET /questions/new
  def new
    @question = Question.new
  end



  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render  :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def answer_create
    question = params[:question]
    @answer = current_user.answer.new(answer_params)
    respond_to do |format|
      if @answer.save
        format.html { redirect_to :return_to, notice: 'Answer was successfully created.' }
        format.json { redirect_to "question/:question", status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :description, :user_id, :category_id)
    end

    def answer_params
      params.require(:answer).permit(:content, :question_id, :user_id)
    end
end
