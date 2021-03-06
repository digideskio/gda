require 'helper'

module GDA
  class TestNodes < TestCase
    attr_reader :parser

    def setup
      super
      @parser = GDA::SQL::Parser.new
    end

    rails_sql.uniq.each do |sql|
      define_method(:"test_#{sql}") do
        stmt = parser.parse sql
        stmt.ast.each do |node|
          assert node
        end
      end
    end

    def test_depth
      stmt = parser.parse 'SELECT * FROM OMG WHERE 1 = 10'
      assert_operator stmt.ast.to_a.length, :>, 1
    end

    def test_not_equal_operator
      stmt = parser.parse 'SELECT id FROM comments WHERE issue_id = 1 AND type <> 3'
      assert stmt.ast.is_a?(GDA::Nodes::Select)
    end
  end
end
