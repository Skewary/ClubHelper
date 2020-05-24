import React from 'react'
import { $get, $post, $put, img } from '../../utils/global'
import {
    Card,
    Modal,
    Icon,
    DatePicker,
    Drawer,
    List,
    Avatar,
    Divider,
    Col,
    Row,
    Button,
    Table,
    Pagination,
    Form,
    Input,
    Radio,
    InputNumber, Checkbox, Select,
    Upload,
    message
} from 'antd'

import Highlighter from 'react-highlight-words';
import { SearchOutlined } from '@ant-design/icons';


var rowSelection = {
    selectedRowKeys: [],
};


const data = [];

var keyid = 1;
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-百米跑廊`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-大钟广场`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-j1三楼电梯间`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-j1四楼电梯间`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-操场`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-网球场`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++){
    for (let k = 8; k <= 21; k++){
        data.push({
            key: keyid,
            location: `沙河-四公寓一楼`,
            date: `6-${j}`,
            time: `${k}:00-${k+1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-体育馆三楼羽毛球`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-体育馆三楼乒乓球`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-足球场`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-b0-009`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-b0-011`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-雄鹰领飞会议室`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `沙河-导办小会议室`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-体育馆217`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-体育馆148`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-健美操厅`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-百米跑廊1`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-百米跑廊2`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-百米跑廊3`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}

for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-体育馆平台1`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });


        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-体育馆平台2`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-羽毛球训练馆`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-小足球场`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-乒乓球馆`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-室外羽毛球场`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-逸夫楼前`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-操场以及老主楼空地`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}
for (let j = 1; j <= 30; j++) {
    for (let k = 8; k <= 21; k++) {
        data.push({
            key: keyid,
            location: `本部-知行北楼113`,
            date: `6-${j}`,
            time: `${k}:00-${k + 1}:00`,
        });
        keyid++;
    }
}


export class getspace extends React.Component {

    getColumnSearchProps = dataIndex => ({
        filterDropdown: ({setSelectedKeys, selectedKeys, confirm, clearFilters}) => (
            <div style={{padding: 8}}>
                <Input
                    ref={node => {
                        this.searchInput = node;
                    }}
                    placeholder={`Search ${dataIndex}`}
                    value={selectedKeys[0]}
                    onChange={e => setSelectedKeys(e.target.value ? [e.target.value] : [])}
                    onPressEnter={() => this.handleSearch(selectedKeys, confirm, dataIndex)}
                    style={{width: 188, marginBottom: 8, display: 'block'}}
                />

                <Button
                    type="primary"
                    onClick={() => this.handleSearch(selectedKeys, confirm, dataIndex)}//定义搜索按钮
                    icon={<SearchOutlined/>}
                    size="small"
                    style={{width: 90}}
                >
                    Search
                </Button>
                <Button onClick={() => this.handleReset(clearFilters)} size="small" style={{width: 90}}>
                    Reset
                </Button>

            </div>
        ),
        filterIcon: filtered => <SearchOutlined style={{color: filtered ? '#1890ff' : undefined}}/>,
        onFilter: (value, record) =>
            record[dataIndex].toString().toLowerCase().includes(value.toLowerCase()),
        onFilterDropdownVisibleChange: visible => {
            if (visible) {
                setTimeout(() => this.searchInput.select());
            }
        },
        render: text =>
            this.state.searchedColumn === dataIndex ? (
                <Highlighter
                    highlightStyle={{backgroundColor: '#ffc069', padding: 0}}//高亮渲染显示搜索结果
                    searchWords={[this.state.searchText]}//搜索关键字
                    autoEscape
                    textToHighlight={text.toString()}
                />
            ) : (
                text
            ),
    });

    handleSearch = (selectedKeys, confirm, dataIndex) => {
        confirm();
        this.setState({
            searchText: selectedKeys[0],
            searchedColumn: dataIndex,
        });
    };

    handleReset = clearFilters => {
        clearFilters();
        this.setState({searchText: ''});
    };

    constructor(props) {
        super(props)
        this.state = {
            selectedRowKeys: [], // Check here to configure the default column
            loading: false,
            searchText: '',
            searchedColumn: '',
        }
    }


    start = () => {
        this.setState({loading: true});

        var ddd = [];
        $get('/activities/pos_time').then(res => {
            if (res.success) {
                let kkk = res.data.pos_time_list;
                for (let i = 0; i < kkk.length; i++) {

                    // let entry = kkk[i];
                    // if (entry.position == "沙河-百米跑廊" && entry.act_date == "2020-06-01")
                    //     ddd.push(1);
                    // if (entry.fin_time == "10:00:00")
                    //     ddd.push(2);
                    // if (entry.beg_time == "09:00:00")
                    //     ddd.push(3);
                    let entry = kkk[i];
                    var tag = 0;
                    if(entry.position == "沙河-百米跑廊"){
                        tag = 1;
                    }
                    else if (entry.position == "沙河-大钟广场"){
                        tag = 421;
                    }
                    else if (entry.position == "沙河-j1三楼电梯间"){
                        tag = 841;
                    }
                    else if (entry.position == "沙河-j1四楼电梯间"){
                        tag = 1261;
                    }
                    else if (entry.position == "沙河-操场"){
                        tag = 1681;
                    }
                    else if (entry.position == "沙河-网球场"){
                        tag = 2101;
                    }
                    else if (entry.position == "沙河-四公寓一楼"){
                        tag = 2521;
                    }
                    else if (entry.position == "沙河-体育馆三楼羽毛球"){
                        tag = 2941;
                    }
                    else if (entry.position == "沙河-体育馆三楼乒乓球"){
                        tag = 3361;
                    }
                    else if (entry.position == "沙河-足球场"){
                        tag = 3781;
                    }
                    else if (entry.position == "沙河-b0-009"){
                        tag = 4201;
                    }
                    else if (entry.position == "沙河-b0-011"){
                        tag = 4621;
                    }
                    else if (entry.position == "沙河-雄鹰领飞会议室"){
                        tag = 5041;
                    }
                    else if (entry.position == "沙河-导办小会议室"){
                        tag = 5461;
                    }
                    else if (entry.position == "本部-体育馆217"){
                        tag = 5881;
                    }
                    else if (entry.position == "本部-体育馆148"){
                        tag = 6301;
                    }
                    else if (entry.position == "本部-健美操厅"){
                        tag = 6721;
                    }
                    else if (entry.position == "本部-百米跑廊1"){
                        tag = 7141;
                    }
                    else if (entry.position == "本部-百米跑廊2"){
                        tag = 7561;
                    }
                    else if (entry.position == "本部-百米跑廊3"){
                        tag = 7981;
                    }
                    else if (entry.position == "本部-体育馆平台1"){
                        tag = 8401;
                    }
                    else if (entry.position == "本部-体育馆平台2"){
                        tag = 8821;
                    }
                    else if (entry.position == "本部-羽毛球训练馆"){
                        tag = 9241;
                    }
                    else if (entry.position == "本部-小足球场"){
                        tag = 9661;
                    }
                    else if (entry.position == "本部-乒乓球馆"){
                        tag = 10081;
                    }
                    else if (entry.position == "本部-室外羽毛球场"){
                        tag = 10501;
                    }
                    else if (entry.position == "本部-逸夫楼前"){
                        tag = 10921;
                    }
                    else if (entry.position == "本部-操场以及老主楼空地"){
                        tag = 11341;
                    }
                    else if (entry.position == "本部-知行北楼113"){
                        tag = 11761;
                    }
                    else {
                        continue;
                    }

                    if(entry.act_date == "2020-06-01"){
                        tag += 0;
                    }
                    else if(entry.act_date == "2020-06-02"){
                        tag += 14;
                    }
                    else if(entry.act_date == "2020-06-03"){
                        tag += 14*2;
                    }
                    else if(entry.act_date == "2020-06-04"){
                        tag += 14*3;
                    }
                    else if(entry.act_date == "2020-06-05"){
                        tag += 14*4;
                    }
                    else if(entry.act_date == "2020-06-06"){
                        tag += 14*5;
                    }
                    else if(entry.act_date == "2020-06-07"){
                        tag += 14*6;
                    }
                    else if(entry.act_date == "2020-06-08"){
                        tag += 14*7;
                    }
                    else if(entry.act_date == "2020-06-09"){
                        tag += 14*8;
                    }
                    else if(entry.act_date == "2020-06-10"){
                        tag += 14*9;
                    }
                    else if(entry.act_date == "2020-06-11"){
                        tag += 14*10;
                    }
                    else if(entry.act_date == "2020-06-12"){
                        tag += 14*11;
                    }
                    else if(entry.act_date == "2020-06-13"){
                        tag += 14*12;
                    }
                    else if(entry.act_date == "2020-06-14"){
                        tag += 14*13;
                    }
                    else if(entry.act_date == "2020-06-15"){
                        tag += 14*14;
                    }
                    else if(entry.act_date == "2020-06-16"){
                        tag += 14*15;
                    }
                    else if(entry.act_date == "2020-06-17"){
                        tag += 14*16;
                    }
                    else if(entry.act_date == "2020-06-18"){
                        tag += 14*17;
                    }
                    else if(entry.act_date == "2020-06-19"){
                        tag += 14*18;
                    }
                    else if(entry.act_date == "2020-06-20"){
                        tag += 14*19;
                    }
                    else if(entry.act_date == "2020-06-21"){
                        tag += 14*20;
                    }
                    else if(entry.act_date == "2020-06-22"){
                        tag += 14*21;
                    }
                    else if(entry.act_date == "2020-06-23"){
                        tag += 14*22;
                    }
                    else if(entry.act_date == "2020-06-24"){
                        tag += 14*23;
                    }
                    else if(entry.act_date == "2020-06-25"){
                        tag += 14*24;
                    }
                    else if(entry.act_date == "2020-06-26"){
                        tag += 14*25;
                    }
                    else if(entry.act_date == "2020-06-27"){
                        tag += 14*26;
                    }
                    else if(entry.act_date == "2020-06-28"){
                        tag += 14*27;
                    }
                    else if(entry.act_date == "2020-06-29"){
                        tag += 14*28;
                    }
                    else if(entry.act_date == "2020-06-30"){
                        tag += 14*29;
                    }
                    else {
                        continue;
                    }

                    var tag2 = tag;

                    if(entry.beg_time == "08:00:00"){
                        tag += 0;
                    }
                    else if (entry.beg_time == "09:00:00"){
                        tag += 1;
                    }
                    else if (entry.beg_time == "10:00:00"){
                        tag += 2;
                    }
                    else if (entry.beg_time == "11:00:00"){
                        tag += 3;
                    }
                    else if (entry.beg_time == "12:00:00"){
                        tag += 4;
                    }
                    else if (entry.beg_time == "13:00:00"){
                        tag += 5;
                    }
                    else if (entry.beg_time == "14:00:00"){
                        tag += 6;
                    }
                    else if (entry.beg_time == "15:00:00"){
                        tag += 7;
                    }
                    else if (entry.beg_time == "16:00:00"){
                        tag += 8;
                    }
                    else if (entry.beg_time == "17:00:00"){
                        tag += 9;
                    }
                    else if (entry.beg_time == "18:00:00"){
                        tag += 10;
                    }
                    else if (entry.beg_time == "19:00:00"){
                        tag += 11;
                    }
                    else if (entry.beg_time == "20:00:00"){
                        tag += 12;
                    }
                    else if (entry.beg_time == "21:00:00"){
                        tag += 13;
                    }
                    else {
                        continue;
                    }

                   if (entry.fin_time == "09:00:00"){
                        tag2 += 0;
                    }
                    else if (entry.fin_time == "10:00:00"){
                        tag2 += 1;
                    }
                    else if (entry.fin_time == "11:00:00"){
                        tag2 += 2;
                    }
                    else if (entry.fin_time == "12:00:00"){
                        tag2 += 3;
                    }
                    else if (entry.fin_time == "13:00:00"){
                        tag2 += 4;
                    }
                    else if (entry.fin_time == "14:00:00"){
                        tag2 += 5;
                    }
                    else if (entry.fin_time == "15:00:00"){
                        tag2 += 6;
                    }
                    else if (entry.fin_time == "16:00:00"){
                        tag2 += 7;
                    }
                    else if (entry.fin_time == "17:00:00"){
                        tag2 += 8;
                    }
                    else if (entry.fin_time == "18:00:00"){
                        tag2 += 9;
                    }
                    else if (entry.fin_time == "19:00:00"){
                        tag2 += 10;
                    }
                    else if (entry.fin_time == "20:00:00"){
                        tag2 += 11;
                    }
                    else if (entry.fin_time == "21:00:00"){
                        tag2 += 12;
                    }
                    else if (entry.fin_time == "22:00:00"){
                        tag2 += 13;
                    }
                    else {
                        continue;
                    }

                    for (let j = tag; j <= tag2; j++) {
                        ddd.push(j);
                    }

                }
            }
        })

        rowSelection = {
            selectedRowKeys: ddd,
            // onChange: this.onSelectChange,
        };
        // ajax request after empty completing
        setTimeout(() => {
            this.setState({
                selectedRowKeys: [],
                loading: false,
            });
        }, 3000);
    };


    onSelectChange = selectedRowKeys => {
        console.log('selectedRowKeys changed: ', selectedRowKeys);
        this.setState({selectedRowKeys});
    };

    render() { //change

        const columns = [
            {
                title: '地点',
                dataIndex: 'location',
                key: 'location',
                width: '30%',
                ...this.getColumnSearchProps('location'),
            },
            {
                title: '日期',
                dataIndex: 'date',
                key: 'date',
                width: '20%',
                ...this.getColumnSearchProps('date'),
            },
            {
                title: '时间',
                dataIndex: 'time',
                key: 'time',
                ...this.getColumnSearchProps('time'),
            },
        ];

        const {loading, selectedRowKeys} = this.state;

        const Pagination = {
            defaultPageSize: 7
        };

        const hasSelected = selectedRowKeys.length > 0;

        return (
            <div>
                <div style={{ marginBottom: 16 }}>
                <Button type="primary" onClick={this.start} disabled={false} loading={loading}>
                    查询/刷新
                </Button>
                <span style={{ marginLeft: 8 }}>
                {hasSelected ? `Selected ${selectedRowKeys.length} items` : ''}
                </span>
                </div>
                <Table rowSelection={rowSelection} columns={columns} dataSource={data} pagination={Pagination}/>
            </div>

        );
    }
}
