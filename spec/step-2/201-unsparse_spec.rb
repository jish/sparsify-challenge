# encoding: utf-8
#
# STEP 2-1
#
# Implement Sparsify::unsparse to do just the opposite of Sparsify::sparse,
# converting a flat sparse hash with dot-separated keys like:
#
# ```ruby
# {
#   'id'                => '196302235',
#   'screen_name'       => '@cascadiaruby',
#   'counts.followers'  => 527,
#   'counts.following'  => 322,
#   'counts.listed'     => 41,
#   'counts.statuses'   => 1022,
#   'meta.updated_at'   => '2013-10-17T03:36:17Z',
#   'meta.created_at'   => '2010-09-28T20:21:29Z'
# }
# ```
#
# into a nested hash like:
#
# ```ruby
# {
#   'id'          => '196302235',
#   'screen_name' => '@cascadiaruby',
#   'counts'      => {
#     'followers'   => 527,
#     'following'   => 322,
#     'listed'      => 41,
#     'statuses'    => 1022
#   },
#   'meta'        => {
#     'updated_at'  => '2013-10-17T03:36:17Z',
#     'created_at'  => '2010-09-28T20:21:29Z'
#   }
# }
# ```

load File.expand_path('../../spec_helper.rb', __FILE__)

describe :Sparsify do
  subject { Sparsify }

  it "should respond to .unsparse" do
    expect(Sparsify.respond_to?(:unsparse)).to be true
  end

  describe '::unsparse' do
    context 'when called with no arguments' do
      it 'should raise' do
        expect { Sparsify::unsparse }.to raise_exception(ArgumentError, /wrong number of arguments/)
      end
    end

    context 'when given a flat hash' do
      let(:source) do
        {
          'foo' => 'bar',
          'baz' => 'baz'
        }
      end
      context 'the result' do
        subject { Sparsify::unsparse(source) }
        it { should eq source } # should be equivalent
        it { should_not equal source } # should *not* be identical
      end
    end

    context 'when given a flat hash representing a nested hash' do
      let(:source) do
        {
          'foo' => 'bar',
          'stats.2012-01-01.likes' => 21,
          'stats.2012-01-01.followers' => 14,
          'stats.2012-01-02.likes' => 27,
          'stats.2012-01-02.followers' => 12,
          'stats.2012-01-03.likes' => 39,
          'stats.2012-01-03.followers' => 17,
          'stats.2012-01-04.likes' => 74,
          'stats.2012-01-04.followers' => 29
        }
      end
      let(:intended_result) do
        {
          'foo' => 'bar',
          'stats' => {
            '2012-01-01' => {
              'likes' => 21,
              'followers' => 14
              },
            '2012-01-02' => {
              'likes' => 27,
              'followers' => 12
            },
            '2012-01-03' => {
              'likes' => 39,
              'followers' => 17
            },
            '2012-01-04' => {
              'likes' => 74,
              'followers' => 29
            }
          }
        }
      end
      context 'the result' do
        subject { Sparsify::unsparse(source) }
        it { should eq intended_result }
      end
    end
  end
end
