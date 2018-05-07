module ApplicationHelper
	def error_message obj
		return '' if obj.errors.empty?

		messages = obj.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
		html = <<-HTML
		<div class="alert alert-danger alert-dismissible show" role="alert">
			<button type="button" class="close" data-dismiss="alert">
				<span aria-hidden="true">&times;</span>
			</button>
			<h4>
				#{pluralize(obj.errors.count, "error")} must be fixed
			</h4>
			#{messages}
		</div>
		HTML

		html.html_safe
	end
end
