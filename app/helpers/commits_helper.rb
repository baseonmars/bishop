module CommitsHelper
  def commit_status_controls(commit)
    status = commit.status
    # nil show Unset, Put in, Block
    buttons = []
    
    # buttons << '<input type="hidden"name="commit[changes_text]" value="#{commit.changes_text}"/>
    #              <input type="hidden"name="commit[testing_text]" value="#{commit.testing_test}"/>'
    
    unless status == 'unset'
      buttons << '<button type="submit" class="neutral unset">Un set</button>
                <input type="hidden"name="commit[status]" value="unset"/>'
    end

    unless status == 'goes_in'
      buttons << '<button type="submit" class="positive goes-in">Put in</button>
                <input type="hidden"name="commit[status]" value="goes_in"/>'
    end

    unless status == 'blocked'
      buttons << '<button type="submit" class="negative blocked">Block</button>
                <input type="hidden"name="commit[status]" value="blocked"/>'
    end
    
    buttons
  end

  def commit_status(commit)
    statuses = {"unset" => "Unset", "goes_in" => "Goes in", "blocked" => "Blocked"}
    statuses[commit.status]
  end
  
  
  def details_style(commit)
    if commit.status != 'unset'
      return 'style="display: none"'
    end
  end
  
end
