#describe Movie do
#  fixtures :movies
#  it 'should include rating and year' do
#    movie = movies(:sad_movie)
#    movie.name_with_rating.should == 'The Notebook (PG)'
#  end
#end

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        #expect(Tmdb::Movie).to receive(:find).with(hash_including :title => 'Inception')
        expect(Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      #it 'should successfully add from tmdb' do
      #  #allow(Movie).to receive(:create_from_tmdb).with("1")#.and_return(@fake_results)
      #  expect(Tmdb::Movie).to receive(:detail).with(1)
      #  Movie.create_from_tmdb(1)
      #end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(NoMethodError)
        allow(Tmdb::Api).to receive(:response).and_return({'code' => '401'})
        expect { Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
    context 'with invalid key' do
      it 'should raise tmdb_gem_exception if error is not caused by - key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(NoMethodError)
        allow(Tmdb::Api).to receive(:response).and_return({'code' => '402'})
        expect { Movie.find_in_tmdb('Inception') }.to raise_error
      end
    end

  end
  
  describe 'adding movie from Tmdb' do
    context 'with valid key' do
      it 'should respond to create_from_tmdb' do
        expect(Movie).to respond_to :create_from_tmdb
      end  
      it 'should respond to create_from_tmdb' do
        Movie.create_from_tmdb('1')
      end
    end
  end
end
