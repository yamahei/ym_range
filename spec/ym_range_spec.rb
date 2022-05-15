# frozen_string_literal: true

RSpec.describe YmRange do
  it "has a version number" do
    expect(YmRange::VERSION).not_to be nil
  end

  describe "引数を省略" do
    it "引数を省略した場合、システム年月のdateを使用してコンストラクタを実行します。" do
      obj = YmRange::Checker.new
      # init
      expect(obj.years).to eq [Date.today.year]
      expect(obj.months).to eq [Date.today.month]
      # include
      expect(obj.include?(Date.today.year, Date.today.month)).to eq true
    end
  end

  describe "数字:年および月を表す数字。" do
    it "1976, 7:正しい" do
      obj = YmRange::Checker.new(1976, 7)
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq [7]
      # include
      expect(obj.include?(1976, 7)).to eq true
      expect(obj.include?(1975, 7)).to eq false
      expect(obj.include?(1977, 7)).to eq false
      expect(obj.include?(1976, 6)).to eq false
      expect(obj.include?(1976, 8)).to eq false
    end
    it "12345, 7:年エラー" do
      expect do
        YmRange::Checker.new(12345, 7)
      end.to raise_error(ArgumentError)
    end
    it "1976, 0:月エラー" do
      expect do
        YmRange::Checker.new(1976, 0)
      end.to raise_error(ArgumentError)
    end
    it "1976, 13:月エラー" do
      expect do
        YmRange::Checker.new(1976, 13)
      end.to raise_error(ArgumentError)
    end
  end

  describe "範囲:年および月の範囲を表すrange。" do
    it "1999..2001, 4..6" do
      obj = YmRange::Checker.new(1999..2001, 4..6)
      # init
      expect(obj.years).to eq [1999, 2000, 2001]
      expect(obj.months).to eq [4, 5, 6]
      # include
      expect(obj.include?(1999, 4)).to eq true
      expect(obj.include?(2000, 5)).to eq true
      expect(obj.include?(2001, 6)).to eq true
      ## 年エラー
      expect(obj.include?(1998, 4)).to eq false
      expect(obj.include?(1998, 6)).to eq false
      expect(obj.include?(2002, 4)).to eq false
      expect(obj.include?(2002, 6)).to eq false
      ## 月エラー
      expect(obj.include?(1999, 3)).to eq false
      expect(obj.include?(1999, 7)).to eq false
      expect(obj.include?(2001, 3)).to eq false
      expect(obj.include?(2001, 7)).to eq false
    end
    it "2000..10000, 4..6:年エラー" do
      expect do
        YmRange::Checker.new(2000..10000, 4..6)
      end.to raise_error(ArgumentError)
    end
    it "2000..2000, 0..6:月エラー" do
      expect do
        YmRange::Checker.new(2000..2000, 0..6)
      end.to raise_error(ArgumentError)
    end
    it "2000..2000, 4..13:月エラー" do
      expect do
        YmRange::Checker.new(2000..2000, 4..13)
      end.to raise_error(ArgumentError)
    end
  end

  describe "配列:複数の月を表すarray。（月のみ）" do
    it "1976, [4, 5, 6]:正しい" do
      obj = YmRange::Checker.new(1976, [4, 5, 6])
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq [4, 5, 6]
      # include
      expect(obj.include?(1976, 4)).to eq true
      expect(obj.include?(1976, 5)).to eq true
      expect(obj.include?(1976, 6)).to eq true
      expect(obj.include?(1976, 3)).to eq false
      expect(obj.include?(1976, 7)).to eq false
    end
  end

  describe "引数型の組み合わせ:全部は大変なので省略" do
    # nil, number, range, array
    it "(nil, number)" do
      obj = YmRange::Checker.new(nil, 7)
      # init
      expect(obj.years).to eq (0..9999).to_a
      expect(obj.months).to eq [7]
    end
    it "(number, range)" do
      obj = YmRange::Checker.new(1976, 4..6)
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq [4, 5, 6]
    end
    it "(range, array)" do
      obj = YmRange::Checker.new(1976..1978, [4, 5, 6])
      # init
      expect(obj.years).to eq [1976, 1977, 1978]
      expect(obj.months).to eq [4, 5, 6]
    end
  end

  describe "YM-string:nil, number, range, array（月のみ）を表す文字列を/区切りで指定します。" do
    it "'1976/7': (1976, 7)と同じ" do
      obj = YmRange::Checker.new("1976/7")
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq [7]
    end
    it "'1976-2000/7': (1976..2000, 7)と同じ" do
      obj = YmRange::Checker.new("1976-2000/7")
      # init
      expect(obj.years).to eq (1976..2000).to_a
      expect(obj.months).to eq [7]
    end
    it "'1976/7-12': (1976, 7..12)と同じ" do
      obj = YmRange::Checker.new("1976/7-12")
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq (7..12).to_a
    end
    it "'*/7': (nil, 7)と同じ" do
      obj = YmRange::Checker.new("*/7")
      # init
      expect(obj.years).to eq (0..9999).to_a
      expect(obj.months).to eq [7]
    end
    it "'1976/*': (1976, nil)と同じ" do
      obj = YmRange::Checker.new("1976/*")
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq (1..12).to_a
    end
    it "'1976/7,8': (1976, [7, 8])と同じ" do
      obj = YmRange::Checker.new("1976/7,8")
      # init
      expect(obj.years).to eq [1976]
      expect(obj.months).to eq [7, 8]
    end
    it "'12345/1':年エラー" do
      expect do
        YmRange::Checker.new("12345/1")
      end.to raise_error(ArgumentError)
    end
    it "'1-12345/1':年エラー" do
      expect do
        YmRange::Checker.new("1-12345/1")
      end.to raise_error(ArgumentError)
    end
    it "'1976/0':月エラー" do
      expect do
        YmRange::Checker.new("1976/0")
      end.to raise_error(ArgumentError)
    end
    it "'1976/13':月エラー" do
      expect do
        YmRange::Checker.new("1976/13")
      end.to raise_error(ArgumentError)
    end
    it "'1976/0..5':月エラー" do
      expect do
        YmRange::Checker.new("1976/0..5")
      end.to raise_error(ArgumentError)
    end
    it "'1976/6..13':月エラー" do
      expect do
        YmRange::Checker.new("1976/6..13")
      end.to raise_error(ArgumentError)
    end
    it "'1976/0,1,2':月エラー" do
      expect do
        YmRange::Checker.new("1976/0,1,2")
      end.to raise_error(ArgumentError)
    end
    it "'1976/11,12,13':月エラー" do
      expect do
        YmRange::Checker.new("1976/11,12,13")
      end.to raise_error(ArgumentError)
    end
  end

end
