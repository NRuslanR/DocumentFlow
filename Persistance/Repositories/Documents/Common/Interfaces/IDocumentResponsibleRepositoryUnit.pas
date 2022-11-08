unit IDocumentResponsibleRepositoryUnit;

interface

uses

  SysUtils,
  Classes,
  DomainObjectUnit,
  Employee,
  Department;

type

  TDocumentResponsible = class (TDomainObject)

  end;

  TDocumentResponsibleRepositoryException = class (Exception)

  end;

  TDocumentResponsibleNotFoundException = class (TDocumentResponsibleRepositoryException)

  end;

  TDocumentResponsibleDepartmentNotFoundException =
    class (TDocumentResponsibleRepositoryException)

    end;
    
  IDocumentResponsibleRepository = interface

    function FindDocumentResponsibleById(
      const ResponsibleId: Variant
    ): TEmployee;

    function FindDocumentResponsibleDepartmentById(
      const DepartmentId: Variant
    ): TDepartment;

    procedure UpdateDocumentResponsible(DocumentResponsible: TEmployee);
    
  end;

implementation

end.
