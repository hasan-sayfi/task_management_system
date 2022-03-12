class Role {
  int roleID;
  final String roleName;

  // Constructor
  Role({
    required this.roleID,
    required this.roleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'deptID': roleID,
      'deptName': roleName,
    };
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
