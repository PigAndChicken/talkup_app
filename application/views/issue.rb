module TalkUp
  module Views
    # View objects for issue data
    class Issue
      def initialize(issue_info)
        @issue_info = issue_info
      end

      def id
        @issue_info.id
      end

      def title
        @issue_info.title
      end

      def description
        @issue_info.description
      end

      def process
        @issue_info.process
      end

      def section
        @issue_info.section
      end

      def owner_username
        @issue_info.owner.username
      end

      def owner_emal
        @issue_info.owner.email
      end

      def collaborators
        # @issue_info.collaborators
      end

    end
  end
end
