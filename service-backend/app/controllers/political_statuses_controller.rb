class PoliticalStatusesController < ApplicationController
  def index#列举所有的政治面貌信息
    data = []
    PoliticalStatus.find_each do |record|
      data.append(
          {
              id: record.id,
              name: record.name
          }
      )
    end

    render status: 200, json: response_json(
        true,
        message: "Get all political status successfully!",
        data:
            {
                political_statuses: data
            }
    )
  end
end
