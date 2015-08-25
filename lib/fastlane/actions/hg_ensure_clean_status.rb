module Fastlane
  module Actions
    module SharedValues
      HG_REPO_WAS_CLEAN_ON_START = :HG_REPO_WAS_CLEAN_ON_START
    end
    # Raises an exception and stop the lane execution if the repo is not in a clean state
    class HgEnsureCleanStatusAction < Action
      def self.run(params)
        options = {
          ignore_untracked: true
        }.merge(params || {})

        cmd = if options[:ignore_untracked] then 'hg status -mard' else 'hg status' end

        repo_clean = cmd.empty?

        if repo_clean
          Helper.log.info 'Mercurial status is clean, all good! 😎'.green
          Actions.lane_context[SharedValues::HG_REPO_WAS_CLEAN_ON_START] = true
        else
          raise 'Mercurial repository is dirty! Please ensure the repo is in a clean state by commiting/stashing/discarding all changes first.'.red
        end
      end

      def self.description
        "Raises an exception if there are uncommited hg changes"
      end

      def self.output
        [
          ['HG_REPO_WAS_CLEAN_ON_START', 'Stores the fact that the hg repo was clean at some point']
        ]
      end

      def self.available_options
        [
          ['ignore_untracked', 'Ignore untracked files?']
        ]
      end

      def self.author
        # credits to lmirosevic for original git version
        "sjrmanning"
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
