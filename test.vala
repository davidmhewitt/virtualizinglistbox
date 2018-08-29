// vim: set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4:


const int N = 1000;

class Data : GLib.Object
{
	public int index;

	public Data (int i) { index = i; }
}

class Row : VirtualizingListBoxRow<Data>
{
	private Gtk.Label label;
	public Row ()
	{
		var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);

		label = new Gtk.Label ("Foobar \\o/");
		label.ellipsize = Pango.EllipsizeMode.END;
		label.hexpand = true;
		label.halign = Gtk.Align.START;
		box.add (label);

		var button = new Gtk.Button.with_label ("Click Me");
		box.add (button);

		box.margin = 6;
		this.add (box);
	}

	public void assign (Data d)
	{
		this.label.label = "\\o/ %d".printf (d.index);
	}
}

void main (string[] args)
{
	Gtk.init (ref args);
	var window = new Gtk.Window ();
	var list = new VirtualizingListBox<Data> ();
	list.activate_on_single_click = false;
	list.selection_mode = Gtk.SelectionMode.MULTIPLE;
	var model = new VirtualizingListBoxModel<Data> ();
	var scroller = new Gtk.ScrolledWindow (null, null);


	try {
		var provider = new Gtk.CssProvider ();
		provider.load_from_data (".list-row { border-bottom: 1px solid alpha(grey, 0.3);}",-1);
		Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (),
		                                          provider,
		                                          Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
	} catch (GLib.Error e) {
		error (e.message);
	}

	for (int i = 0; i < N; i ++) {
		// dummy
		model.set (i, new Data (i));
	}



	list.model = model;
	list.factory_func = (item, old_widget) => {
		Row? row = null;
		if (old_widget != null) row = old_widget as Row;
		else                    row = new Row ();

		row.assign ((Data)item);
		row.show_all ();
		return row;
	};

	scroller.add (list);
	window.add (scroller);

	window.resize (400, 400);
	window.show_all ();
	Gtk.main ();
}
