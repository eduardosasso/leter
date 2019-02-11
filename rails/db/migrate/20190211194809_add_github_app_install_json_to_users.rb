class AddGithubAppInstallJsonToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_app, :json
		add_column :users, :github_app_install_id, :integer
  end
end
