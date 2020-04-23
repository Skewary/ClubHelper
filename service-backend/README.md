## service-backend
 ~~万一写错了还能版本回退~~

#### 是否有活动待评价，是否有活动在申请中

* boolean:applying，但db中是has_activities_applying

* boolean:unevaluated但db中是has_activities_unevaluated

#### 评分，理由，建议

* integer:rank
* text:reason
* text:suggestion

