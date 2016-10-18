require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end
    it 'should call the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('Ted').and_return(@fake_results)
      post :search_tmdb, {:search_box => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
      post :search_tmdb, {:search_box => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end
    
    it 'should redirect to the home page for a none-existing movie' do
      allow(Movie).to receive(:find_in_tmdb).with('jazariatexasokali').and_return([])
      post :search_tmdb, {:search_box => 'jazariatexasokali'}
      expect(response).to redirect_to movies_path
    end

    it 'should flash a warning for a none-existing movie' do
      allow(Movie).to receive(:find_in_tmdb).with('jazariatexasokali').and_return([])
      post :search_tmdb, {:search_box => 'jazariatexasokali'}
      expect(flash[:warning]).to eq "No matching movies were found on TMDb"
    end

    it 'search without giving a title should flash a warning message' do
      allow(Movie).to receive(:search_tmdb).with("")
      post :search_tmdb, {:search_box => ""}
      expect(flash[:warning]).to eq "Invalid search term"
    end

    it 'should make the TMDb search results available to that template' do
      allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
      post :search_tmdb, {:search_box => 'Ted'}
      #look for controller method to assign @movies
      expect(assigns(:movies)).to eq @fake_results
    end
    
    it 'should flash a notice message on successfully adding adding from tmdb' do
      allow(Movie).to receive(:create_from_tmdb).with("1")#.and_return(@fake_results)
      post :add_tmdb, {:checkbox =>{"1" => "1"}}
      expect(response).to redirect_to movies_path
    end
    
    it 'should flash a notice message on successfully adding from tmdb' do
      allow(Movie).to receive(:create_from_tmdb).with("1")#.and_return(@fake_results)
      post :add_tmdb, {:checkbox =>{"1" => "1"}}
      expect(flash[:notice]).to eq "Movies successfully added to Rotten Potatoes"
    end
    it 'should flash a warning when no movie is selected' do
      allow(Movie).to receive(:tmdb_movies).with('').and_return([])
      post :add_tmdb, {:checkbox => ''}
      expect(flash[:warning]).to eq "No movies selected"
    end
    
  end
end