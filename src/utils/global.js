//const baseUrl = 'https://admin.software.questionor.cn/api'
//const baseUrl = 'http://localhost/api'
const baseUrl = 'http://114.115.141.131/api'
//const baseUrl = ''
const headers = {
  'content-type': 'application/json'
}

export function $get(url) {
  console.log('get:')
  console.log(url)
  return fetch(baseUrl + url, {
    credentials: 'include',
    headers: headers,
    method: 'GET'
  }).then(res => res.json())
}

export function $post(url, data) {
  console.log('post:')
  console.log(url)
  console.log(data)
  return fetch(baseUrl + url, {
    credentials: 'include',
    headers: headers,
    method: 'POST',
    body: JSON.stringify(data)
  }).then(res => res.json())
}

export function $put(url, data) {
  console.log('put:')
  console.log(url)
  console.log(data)
  return fetch(baseUrl + url, {
    credentials: 'include',
    headers: headers,
    method: 'PUT',
    body: JSON.stringify(data)
  }).then(res => res.json())
}

export function $delete(url) {
  console.log('post:')
  console.log(url)
  return fetch(baseUrl + url, {
    credentials: 'include',
    headers: headers,
    method: 'DELETE'
  }).then(res => res.json())
}

export function img(url) {
  // return 'https://api.software.hansbug.cn/img' + url
  return 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588087666117&di=53a4cc0eadfe95b152bfbd2329032055&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20150927%2Fmp33530439_1443344499785_1_th.jpeg'
}