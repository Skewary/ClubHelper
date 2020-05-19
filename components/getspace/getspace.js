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
    selectedRowKeys: [1, 5, 12],
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
            location: `本部-小晨星剧场`,
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
                {/*<Space>*/}
                <Button
                    type="primary"
                    onClick={() => this.handleSearch(selectedKeys, confirm, dataIndex)}
                    icon={<SearchOutlined/>}
                    size="small"
                    style={{width: 90}}
                >
                    Search
                </Button>
                <Button onClick={() => this.handleReset(clearFilters)} size="small" style={{width: 90}}>
                    Reset
                </Button>
                {/*</Space>*/}
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
                    highlightStyle={{backgroundColor: '#ffc069', padding: 0}}
                    searchWords={[this.state.searchText]}
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
        rowSelection = {
            selectedRowKeys: [2],
            onChange: this.onSelectChange,
        };
        // ajax request after empty completing
        setTimeout(() => {
            this.setState({
                selectedRowKeys: [],
                loading: false,
            });
        }, 1000);
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
