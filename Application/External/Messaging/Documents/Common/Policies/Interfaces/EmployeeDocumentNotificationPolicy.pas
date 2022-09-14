unit EmployeeDocumentNotificationPolicy;

interface

uses

  Employee;

type

  IEmployeeDocumentNotificationPolicy = interface

    function CanNotifyEmployeeAboutDocument(
      Employee: TEmployee
    ): Boolean;

  end;

implementation

end.
