namespace SafeResourcePicker;

using Godot;

[Tool]
[GlobalClass]
public partial class SafeResourcePickerInspectorPlugin : EditorInspectorPlugin
{
	private const string TYPE_NOT_SUPPORTED_ERROR_STRING =
		"SafeResourcePicker: Property \"{1}\" is of type {2}, which is an invalid SafeResourcePicker type. Please use either String, StringName, Array, Array[String], Array[StringName], or PackedStringArray.";
	
	public override bool _CanHandle(GodotObject _object)
	{
		return true;
	}

	public override bool _ParseProperty(GodotObject @object, Variant.Type type, string name, PropertyHint hintType, string hintString,
		PropertyUsageFlags usageFlags, bool wide)
	{
		if(hintType != SRP_HINT.RESOURCE_PATH)
		{
			return false;
		}
		if(type == Variant.Type.String || type == Variant.Type.StringName)
		{
			var parameters = new Variant[1];
			parameters[0] = hintString;
			var prop = (Control)GD.Load<GDScript>("res://addons/safe_resource_picker/editor_property.gd")
				.New(parameters);
			AddPropertyEditor(name, prop);
			return true;
		}
		else if(type == Variant.Type.Array || type == Variant.Type.PackedStringArray)
		{
			var parameters = new Variant[2];
			parameters[0] = (long)type;
			parameters[1] = hintString;
			var prop = (Control)GD.Load<GDScript>("res://addons/safe_resource_picker/array/array_editor_property.gd")
				.New(parameters);
			AddPropertyEditor(name, prop);
			return true;
		}
		else
		{
			GD.PrintErr(TYPE_NOT_SUPPORTED_ERROR_STRING, name, type.ToString());
			return false;
		}
	}
}