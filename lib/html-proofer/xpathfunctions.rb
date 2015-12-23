module HTML
  class Proofer
    class XpathFunctions
      def case_insensitive_equals(node_set, str_to_match)
        node_set.find_all { |node| node.to_s.downcase == str_to_match.to_s.downcase }
      end
    end
  end
end
