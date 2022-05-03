module Constraints
  class SetupWizardConstraint
    def matches?(request)
      setup_on = BoltOn.find_by(name: "Setup")
      return (setup_on.nil? ? true : setup_on.enabled?)
    end
  end
end
