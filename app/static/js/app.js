var ENTER_KEY = 13;
var ESCAPE_KEY = 27;

var util = {
	uuid: function () {
		/*jshint bitwise:false */
		var i, random;
		var uuid = '';

		for (i = 0; i < 32; i++) {
			random = Math.random() * 16 | 0;
			if (i === 8 || i === 12 || i === 16 || i === 20) {
				uuid += '-';
			}
			uuid += (i === 12 ? 4 : (i === 16 ? (random & 3 | 8) : random)).toString(16);
		}

		return uuid;
	},
	pluralize: function (count, word) {
		return count === 1 ? word : word + 's';
	}
};


(function (L) {
    var _this = null;
    L.Todo = L.Todo || {};
    _this = L.Todo = {
        todo: [],
        filter: "all",

        init: function () {
			_this.todos = [];
			_this.todoTemplate = function(todos){
				console.dir(todos)
				var data = {
					list: todos
				};
				var tpl = $('#todo-template').html();
				return juicer(tpl, data);
			}
			_this.footerTemplate =  function(data){
				var tpl = $('#footer-template').html();
				return juicer(tpl, data)
			}

			_this.bindEvents();
			_this.getByType("all");
			
		},

		getByType: function(filter){
			var self = _this;
			$.ajax({
                url : '/todo/find/'+filter,
                type : 'get',
                data : {},
                dataType : 'json',
                success : function(result) {
          			if(result.success ){
          				self.todos = result.data;
          				self.filter = filter
          				self.render();
          			}else{
          				self.tip(result.msg);
          			}
                },
                error : function() {
                	self.tip("error to find todos");
                }
            });
		},

		tip: function(msg){
			$('#tipMsg').text("Tip: " + msg).show();
		},

		bindEvents: function () {
			$('#new-todo').on('keyup', _this.create.bind(_this));
			$('#toggle-all').on('change', _this.toggleAll.bind(_this));
			$('#footer').on('click', '#clear-completed', _this.destroyCompleted.bind(_this));
			$('#todo-list')
				.on('change', '.toggle', _this.toggle.bind(_this))
				.on('dblclick', 'label', _this.edit.bind(_this))
				.on('keyup', '.edit', _this.editKeyup.bind(_this))
				.on('focusout', '.edit', _this.update)
				.on('click', '.destroy', _this.destroy.bind(_this));

			$(document).on('click', '#filters li a',function(){
				var filter = $(this).attr("data-filter")
				_this.getByType(filter);
			});
		},
		render: function () {
			var todos = _this.getFilteredTodos();
			$('#todo-list').html(_this.todoTemplate(todos));
			$('#main').toggle(todos.length > 0);
			$('#toggle-all').prop('checked', _this.getActiveTodos().length === 0);
			_this.renderFooter();
			$('#new-todo').focus();
		},
		renderFooter: function () {
			var todoCount = _this.todos.length;
			var activeTodoCount = $("#todo-list").children().length;
			console.log("todoCount", todoCount, "activeTodoCount", activeTodoCount)

			var template = _this.footerTemplate({
				activeTodoCount: activeTodoCount,
				activeTodoWord: util.pluralize(activeTodoCount, 'item'),
				filter: _this.filter
			});

			$('#footer').html(template);
		},
		toggleAll: function (e) {
			var isChecked = $(e.target).prop('checked');

			_this.todos.forEach(function (todo) {
				todo.completed = isChecked;
			});

			_this.render();
		},
		getActiveTodos: function () {
			return _this.todos.filter(function (todo) {
				return !todo.completed;
			});
		},
		getCompletedTodos: function () {
			return _this.todos.filter(function (todo) {
				return todo.completed;
			});
		},
		getFilteredTodos: function () {
			if (_this.filter === 'active') {
				return _this.getActiveTodos();
			}

			if (_this.filter === 'completed') {
				return _this.getCompletedTodos();
			}

			return _this.todos;
		},
		destroyCompleted: function () {
			console.log("destroy")
			_this.todos = _this.getActiveTodos();
			_this.filter = 'all';
			_this.render();
		},
		// accepts an element from inside the `.item` div and
		// returns the corresponding index in the `todos` array
		indexFromEl: function (el) {
			var id = $(el).closest('li').attr('data-id');
			var todos = _this.todos;
			var i = todos.length;

			while (i--) {
				if (todos[i].id === id) {
					return i;
				}
			}
		},
		create: function (e) {
			var $input = $(e.target);
			var val = $input.val().trim();

			if (e.which !== ENTER_KEY || !val) {
				return;
			}

			var new_todo = {
            	id: util.uuid(),
				title: val,
				completed: false
            };

			$.ajax({
                url : '/todo/add',
                type : 'put',
                data : new_todo,
                dataType : 'json',
                success : function(result) {
          			if(result.success ){
          				_this.todos.push(new_todo);
						$input.val('');
						_this.render();
          			}else{
          				self.tip(result.msg);
          			}
                },
                error : function() {
                	self.tip("error to create todo");
                }
            });
		},
		toggle: function (e) {
			var i = _this.indexFromEl(e.target);
			_this.todos[i].completed = !_this.todos[i].completed;
			var completed = _this.todos[i].completed
			var id = _this.todos[i].id

			$.ajax({
                url : '/todo/complete',
                type : 'post',
                data : {
                	id: id,
                	completed: completed
                },
                dataType : 'json',
                success : function(result) {
          			if(result.success ){
						_this.render();
          			}else{
          				self.tip(result.msg);
          			}
                },
                error : function() {
                	self.tip("error to mark todo completed status");
                }
            });
		},
		edit: function (e) {
			var $input = $(e.target).closest('li').addClass('editing').find('.edit');
			$input.val($input.val()).focus();
		},
		editKeyup: function (e) {
			if (e.which === ENTER_KEY) {
				e.target.blur();
			}

			if (e.which === ESCAPE_KEY) {
				$(e.target).data('abort', true).blur();
			}
		},
		update: function (e) {
			var el = e.target;
			var $el = $(el);
			var val = $el.val().trim();

			if (!val) {
				_this.destroy(e);
				return;
			}

			if ($el.data('abort')) {
				$el.data('abort', false);
			} else {
				console.log(_this.indexFromEl(el))

				var index  = _this.indexFromEl(el);
				
				
				var todo = _this.todos[index];
				var id = todo.id;

				$.ajax({
	                url : '/todo/update',
	                type : 'post',
	                data : {
	                	id: id,
	                	title: val
	                },
	                dataType : 'json',
	                success : function(result) {
	          			if(result.success ){
							_this.todos[index].title = val;
							_this.render();
	          			}else{
	          				self.tip(result.msg);
	          			}
	                },
	                error : function() {
	                	self.tip("error to update todo");
	                }
	            });
			}
		},

		destroy: function (e) {
			var index  = _this.indexFromEl(e.target);
			var todo = _this.todos[index];
			var id = todo.id;

			$.ajax({
                url : '/todo/delete',
                type : 'delete',
                data : {
                	todoId: id
                },
                dataType : 'json',
                success : function(result) {
          			if(result.success ){
						_this.todos.splice(index, 1);
						_this.render();
          			}else{
          				self.tip(result.msg);
          			}
                },
                error : function() {
                	self.tip("error to delete todo");
                }
            });
		},

        formatDate: function (now) {
            var year = now.getFullYear();
            var month = now.getMonth() + 1;
            var date = now.getDate();
            var hour = now.getHours();
            var minute = now.getMinutes();
            var second = now.getSeconds();
            if (second < 10) second = "0" + second;
            return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second;
        }
    };
}(Lor));
