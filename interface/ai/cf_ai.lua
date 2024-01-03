function init()
  self.config = config.getParameter("aiConfig")

  goBack()
end

function goBack()
  widget.setVisible("backButton", false)

  widget.setVisible("showMissions", true)
  widget.setVisible("showPrimaryMissions", false)
  widget.setVisible("showSecondaryMissions", false)
  widget.setVisible("showCrew", true)
  widget.setVisible("showMisc", true)

  widget.setVisible("mainStack.aiStatusRect", true)
  widget.setVisible("mainStack.missionStack", false)
  widget.setVisible("mainStack.crewStack", false)
  widget.setVisible("mainStack.miscStack", false)
end

function showMissions()
  widget.setVisible("backButton", true)

  widget.setVisible("showMissions", false)
  widget.setVisible("showPrimaryMissions", true)
  widget.setVisible("showSecondaryMissions", true)
  widget.setVisible("showCrew", false)
  widget.setVisible("showMisc", false)

  local noMissions = true
  for m, mission in pairs(self.config.missions.primary) do
    if player.hasCompletedQuest(mission.quest) or player.hasQuest(mission.quest) then
      missionData = root.assetJson(mission.path)
      
      if missionData then
        local listItem = "mainStack.missionStack.scrollArea.missionItemList." .. widget.addListItem("mainStack.missionStack.scrollArea.missionItemList")
        widget.setText(listItem .. ".itemName", missionData.speciesText.default.buttonText)
        widget.setImage(listItem .. ".itemIcon", "/ai/" .. missionData.icon)
        widget.setData(listItem, { missionWorld = missionData.missionWorld, completed = player.hasCompletedQuest(mission.quest) })

        noMissions = false
      end
    end
  end
  for m, mission in pairs(self.config.missions.secondary) do
    if player.hasCompletedQuest(mission.quest) or player.hasQuest(mission.quest) then
      missionData = root.assetJson(mission.path)
      
      if missionData then
        local listItem = "mainStack.missionStack.scrollArea.missionItemList." .. widget.addListItem("mainStack.missionStack.scrollArea.missionItemList")
        widget.setText(listItem .. ".itemName", missionData.speciesText.default.buttonText)
        widget.setImage(listItem .. ".itemIcon", "/ai/" .. missionData.icon)
        widget.setData(listItem, { missionWorld = missionData.missionWorld, completed = player.hasCompletedQuest(mission.quest) })

        noMissions = false
      end
    end
  end
end

function showPrimaryMissions()

end

function showSecondaryMissions()
    
end

function showCrew()
  widget.setVisible("backButton", true)

  widget.setVisible("showMissions", false)
  widget.setVisible("showCrew", false)
  widget.setVisible("showMisc", false)
end

function showMisc()
  widget.setVisible("backButton", true)

  widget.setVisible("showMissions", false)
  widget.setVisible("showCrew", false)
  widget.setVisible("showMisc", false)
end

function startMission()

end

function dismissRecruit()

end