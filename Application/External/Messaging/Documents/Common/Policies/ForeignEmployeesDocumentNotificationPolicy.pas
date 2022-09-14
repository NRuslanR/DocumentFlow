unit ForeignEmployeesDocumentNotificationPolicy;

interface

uses

  EmployeeDocumentNotificationPolicy,
  Employee,
  SysUtils,
  Classes;

type

  TForeignEmployeesDocumentNotificationPolicy = class (TInterfacedObject, IEmployeeDocumentNotificationPolicy)

    public

      function CanNotifyEmployeeAboutDocument(
        Employee: TEmployee
      ): Boolean;

  end;


implementation

{ TForeignEmployeesDocumentNotificationPolicy }

function TForeignEmployeesDocumentNotificationPolicy.CanNotifyEmployeeAboutDocument(
  Employee: TEmployee): Boolean;
begin

  Result := Employee.IsForeign;
  
end;

end.
