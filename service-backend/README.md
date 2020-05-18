## service-backen
### 是否有活动待评价，是否有活动在申请中

* `boolean:applying`，但db中是has_activities_applying
* `boolean:unevaluated`，但db中是has_activities_unevaluated

-----

### 评分，理由，建议

* `integer:rank`
* `text:reason`
* `text:suggestion`

- 请求路径`/clubs/admin/:club_id/activity/:activity_id/evaluate`
- 请求方法：`PUT`
- 返回数据格式：
  - 保存评价，返回是否成功

------

### 审核反馈

* 审核状态 `boolean:review_state`
* 审核原因 `text:review_reason`
* 请求路径`/clubs/admin/:club_id/activity/:activity_id/review`
* 请求方法：`PUT`
* 返回数据格式：
  - 保存反馈，返回是否成功

----

### 2020.5.18

更新了test文件，修复test中出现Failure的情况，遗留两个error待解决