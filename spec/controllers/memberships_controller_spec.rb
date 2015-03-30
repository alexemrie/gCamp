require 'rails_helper'

describe MembershipsController do
  before :each do
    @user = create_user(admin: false)
    @project = create_project
    @membership = create_membership(user_id: @user.id, project_id: @project.id)
    session[:user_id] = @user.id
  end

  describe "redirect_paths for membership permissions" do
    it 'redirects a non_logged_in user to signin' do
      session.clear
      get :index, project_id: @project.id
      expect(response).to redirect_to "/signin"
    end

    it 'does not allow a logged_in non_project_member to visit memberships index' do
      session.clear
      non_member = create_user(admin: false)
      session[:user_id] = non_member.id
      get :index, project_id: @project.id
      expect(response).to_not render_template :index
      expect(response).to redirect_to projects_path
      expect(flash[:error]).to eq "You do not have access to that project"
    end

    it 'allows a logged_in project member to visit memberships index' do
      get :index, project_id: @project.id
      expect(response).to render_template :index
    end

    it 'allows an admin to visit memberships index for any project' do
      session.clear
      @user_2 = create_user(admin: true)
      session[:user_id] = @user_2.id
      get :index, project_id: @project.id
      expect(response).to render_template :index
    end
  end

  describe "updating a project membership" do
    describe "an owner or admin can update project memberships" do

      it "allows a project_owner to update a membership" do
        user = create_user(admin: false)
        membership = create_membership(project_id: @project.id, user_id: user.id, role: "Member")

        expect{
          patch :update, id: membership.id, project_id: @project.id, membership: {role: "Owner"}
        }.to change {membership.reload.role}.from("Member").to("Owner")

        expect(flash[:success]).to eq("#{user.full_name} was successfully updated")
        expect(response).to redirect_to project_memberships_path
      end

      it "allows an admin to update a membership" do
        session.clear
        admin_user = create_user(admin: true)
        session[:user_id] = admin_user.id

        user = create_user(admin: false)
        membership = create_membership(project_id: @project.id, user_id: user.id, role: "Member")

        expect{
          patch :update, id: membership.id, project_id: @project.id, membership: {role: "Owner"}
        }.to change {membership.reload.role}.from("Member").to("Owner")

        expect(flash[:success]).to eq("#{user.full_name} was successfully updated")
        expect(response).to redirect_to project_memberships_path
      end
    end
  end

  describe "deleting a project membership" do
    describe "an admin/owner can delete a project membership" do
      it 'allows a project owner to delete a membership' do
        user = create_user(admin: false)
        membership = create_membership(project_id: @project.id, user_id: user.id, role: "Member")

        expect{
          delete :destroy, id: membership.id, project_id: @project.id, user_id: user.id, membership: {role: 'Member'}
        }.to change(Membership, :count).by(-1)

        expect(flash[:success]).to eq("#{user.full_name} was successfully removed")
        expect(response).to redirect_to project_memberships_path
      end

      it 'allows an admin to delete a membership' do
        session.clear
        admin_user = create_user(admin: true)
        session[:user_id] = admin_user.id
        user = create_user(admin:false)

        membership = create_membership(project_id: @project.id, user_id: user.id, role: "Member")

        expect{
          delete :destroy, id: membership.id, project_id: @project.id, user_id: user.id, membership: {role: 'Member'}
        }.to change(Membership, :count).by(-1)

        expect(flash[:success]).to eq("#{user.full_name} was successfully removed")
        expect(response).to redirect_to project_memberships_path
      end
    end

    it 'allows a user(non-owner) to delete their own memberships' do
      session.clear
      user = create_user(admin:false)
      session[:user_id] = user.id

      membership = create_membership(project_id: @project.id, user_id: user.id, role: "Member")

      expect{
        delete :destroy, id: membership.id, project_id: @project.id, user_id: user.id, membership: {role: 'Member'}
      }.to change(Membership, :count).by(-1)

      expect(flash[:success]).to eq("#{user.full_name} was successfully removed")
      expect(response).to redirect_to projects_path
    end
  end
end
