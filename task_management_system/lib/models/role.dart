class Role {
  int? roleID;
  final String roleName;

  Role({
    this.roleID,
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
}
