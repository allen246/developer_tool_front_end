<template>
<div>
  <div id="error_notifier"></div>
  <textarea v-model="jsonstr" rows=30% cols=90% id="jsonid"></textarea>
  <br>
  <span>
    <button v-on:click="str_pretty_func()"><a href="#json_data">Stringify Json</a></button>
    <button v-on:click="str_parser_func()"><a href="#json_data">Parse Json</a></button>
    <button v-on:click="json_concate()"><a href="#json_data">Concate Json</a></button>
  </span>
  <div v-if="status=='pretty'">
  <button id="cpy_btn" v-on:click="copyText()">copy</button>
  <pre id='json_data'>{{ jsonstr | str_pretty }}</pre>
  </div>
  <div v-else-if="status=='parser'">
  <button id="cpy_btn" v-on:click="copyText()">copy</button>
  <p id="json_data" >{{ jsonstr | str_parser }}</p>
  </div>
  <p id="json_constr" v-else></p>
  
</div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'json_parser',
  data(){
    var jsonstr= '{"id":1,"name":"A green door","price":12.50,"tags":["home","green"]}'
    var json_con_data = ""
    return {jsonstr:jsonstr, status: "", json_con_data}
  },
  methods: {
    json_parser_post: function()
      {
        axios.post('http://ec2-3-17-186-246.us-east-2.compute.amazonaws.com:8000/api/v1/users/json-formate', this.jsonstr,{"headers": {"content-type": "application/json",}})
        .then((response) => {this.jsonstr = JSON.stringify(response.data)})
        .catch((error) => console.log(error))
    },
    str_pretty_func()
    {
      this.status = 'pretty'
      this.json_parser_post()
      if (this.json_con_data){
        this.jsonstr = this.json_con_data
      }
    },
    str_parser_func()
    {
      this.status = 'parser'
      this.json_parser_post()
      if (this.json_con_data){
        this.jsonstr = this.json_con_data
      }
    },
    json_concate()
    {
      let json_con = document.querySelector('#jsonid')
      this.json_con_data += json_con.value;
      document.getElementById('json_constr').innerText = this.json_con_data
    },
    copyText()
    {
      let data = document.getElementById('json_data').innerHTML;
      navigator.clipboard.writeText(data)
    }
  },
  filters: {
    str_pretty: function(value) {
      try {
      return JSON.stringify(JSON.parse(value), null, 2);
      }
      catch(error){
        let data = document.querySelector('#error_notifier')
        data.innerText = error
        setTimeout(function () {document.getElementById('error_notifier').style.display='none'}, 3000);
        setTimeout(function () {window.location.reload(true)}, 5000);
      }
    },
    str_parser: function(value) {
      try {
      return JSON.parse(value);
      }
      catch(error){
        let data = document.querySelector('#error_notifier')
        data.innerText = error
        setTimeout(function () {document.getElementById('error_notifier').style.display='none'}, 5000);
      }
    }
  }
};
</script>
<style>
#cpy_btn{float: right;}
#json_data{text-align:left;color:green;border-width:5px; border-style:solid;border-color: gray;margin-top: 60px;margin-left: 10px;margin-right: 10px}
#error_notifier{text-align:left;background-color: red;}
a:link, a:visited {
  background-color: red;
  color: white;
  padding: 14px 25px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
}

a:hover, a:active {
  background-color: red;
}
</style>