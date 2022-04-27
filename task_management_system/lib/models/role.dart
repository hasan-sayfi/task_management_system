class Role {
  int? roleID;
  late String roleName;

  // Constructor
  Role({this.roleID, required this.roleName}) {
    roleID = this.roleID;
    roleName = this.roleName;
  }

  Map<String, dynamic> toMap() {
    return {
      'roleID': roleID,
      'roleName': roleName,
    };
  }

  //Extract Task object from MAP object
  Role.fromMapObject(Map<String, dynamic> map) {
    this.roleID = map['roleID'];
    this.roleName = map['roleName'];
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Role(deptID: $roleID,deptName: $roleName)';
  }

  // Dump Data
  List<Role> generateRoles() {
    return [
      Role(roleID: 1, roleName: "Administrator"),
      Role(roleID: 2, roleName: "Manager"),
      Role(roleID: 3, roleName: "Employee"),
    ];
  }
}
