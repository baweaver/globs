RSpec.describe Globs do
  it "has a version number" do
    expect(Globs::VERSION).not_to be nil
  end

  it 'does not expand a normal string' do
    expect(Globs.expand('a_normal_string')).to eq(%w(a_normal_string))
  end

  it 'can expand a single set' do
    expect(
      Globs.expand('test.{a, b, c}.com')
    ).to eq(%w(
      test.a.com
      test.b.com
      test.c.com
    ))
  end

  it 'can expand multiple sets' do
    expect(
      Globs.expand('test.{a, b, c}.{1, 2}.com')
    ).to eq(%w(
      test.a.1.com
      test.a.2.com
      test.b.1.com
      test.b.2.com
      test.c.1.com
      test.c.2.com
    ))
  end

  it 'can expand a range' do
    expect(
      Globs.expand('test.{a..c}.{1, 2}.com')
    ).to eq(%w(
      test.a.1.com
      test.a.2.com
      test.b.1.com
      test.b.2.com
      test.c.1.com
      test.c.2.com
    ))
  end
end
