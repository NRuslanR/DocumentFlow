unit UIDocumentKinds;

interface

type

  TUIDocumentKind = class;
  TUIOutcomingDocumentKind = class;
  TUIApproveableDocumentKind = class;
  TUIIncomingDocumentKind = class;
  TUIInternalDocumentKind = class;
  TUIIncomingInternalDocumentKind = class;
  
  TUIDocumentKindClass = class of TUIDocumentKind;
  TUIApproveableDocumentKindClass = class of TUIApproveableDocumentKind;
  TUIOutcomingDocumentKindClass = class of TUIOutcomingDocumentKind;
  TUIIncomingDocumentKindClass = class of TUIIncomingDocumentKind;
  TUIInternalDocumentKindClass = class of TUIInternalDocumentKind;
  TUIIncomingInternalDocumentKindClass = class of TUIIncomingInternalDocumentKind;
  
  TUIDocumentKind = class

  end;

  TUISDDocumentKind = class (TUIDocumentKind)
  
  end;

  TUIPlantDocumentKind = class (TUIDocumentKind)
  
  end;

  TUIResourceRequestsDocumentKind = class (TUIDocumentKind)
  
  end;

  TUINativeDocumentKind = class (TUIDocumentKind)
  
  end;

  TUIOutcomingDocumentKind = class (TUINativeDocumentKind)

    public

      class function IncomingDocumentKind: TUIIncomingDocumentKindClass; virtual;
      class function ApproveableDocumentKind: TUIApproveableDocumentKindClass; virtual;

  end;

  TUIApproveableDocumentKind = class (TUINativeDocumentKind)

    public

      class function OutcomingDocumentKind: TUIOutcomingDocumentKindClass; virtual;

  end;

  TUIIncomingDocumentKind = class (TUINativeDocumentKind)

    public

      class function OutcomingDocumentKind: TUIOutcomingDocumentKindClass; virtual;

  end;

  TUIInternalDocumentKind = class (TUINativeDocumentKind)


  end;

  TUIIncomingInternalDocumentKind = class (TUIIncomingDocumentKind)

    class function InternalDocumentKind: TUIInternalDocumentKindClass; virtual;
    
  end;

type

  TUIServiceNoteKind = class (TUINativeDocumentKind)

  end;
  
  TUIOutcomingServiceNoteKind = class (TUIOutcomingDocumentKind)

    public

      class function IncomingDocumentKind: TUIIncomingDocumentKindClass; override;
      class function ApproveableDocumentKind: TUIApproveableDocumentKindClass; override;

  end;

  TUIApproveableServiceNoteKind = class (TUIApproveableDocumentKind)

    public

      class function OutcomingDocumentKind: TUIOutcomingDocumentKindClass; override;
      
  end;

  TUIIncomingServiceNoteKind = class (TUIIncomingDocumentKind)

    public

      class function OutcomingDocumentKind: TUIOutcomingDocumentKindClass; override;

  end;

  TUIInternalServiceNoteKind = class (TUIInternalDocumentKind)

      
  end;

  TUIIncomingInternalServiceNoteKind = class (TUIIncomingInternalDocumentKind)

    class function InternalDocumentKind: TUIInternalDocumentKindClass; override;

  end;

type

  TUIOrderKind = class (TUINativeDocumentKind)
  end;

type

  TUIPersonnelOrderKind = class (TUINativeDocumentKind)
  end;
  
implementation

{ TUIOutcomingDocumentKind }

class function TUIOutcomingDocumentKind.ApproveableDocumentKind: TUIApproveableDocumentKindClass;
begin

  Result := TUIApproveableDocumentKind;
  
end;

class function TUIOutcomingDocumentKind.IncomingDocumentKind: TUIIncomingDocumentKindClass;
begin

  Result := TUIIncomingDocumentKind;
  
end;

{ TUIIncomingDocumentKind }

class function TUIIncomingDocumentKind.OutcomingDocumentKind: TUIOutcomingDocumentKindClass;
begin

  Result := TUIOutcomingDocumentKind;
  
end;

{ TUIOutcomingServiceNoteKind }

class function TUIOutcomingServiceNoteKind.ApproveableDocumentKind: TUIApproveableDocumentKindClass;
begin

  Result := TUIApproveableServiceNoteKind;
  
end;

class function TUIOutcomingServiceNoteKind.IncomingDocumentKind: TUIIncomingDocumentKindClass;
begin

  Result := TUIIncomingServiceNoteKind;
  
end;

{ TUIIncomingServiceNoteKind }

class function TUIIncomingServiceNoteKind.OutcomingDocumentKind: TUIOutcomingDocumentKindClass;
begin

  Result := TUIOutcomingServiceNoteKind;
  
end;

{ TUIIncomingInternalDocumentKind }

class function TUIIncomingInternalDocumentKind.InternalDocumentKind: TUIInternalDocumentKindClass;
begin

  Result := TUIInternalDocumentKind;
  
end;

{ TUIIncomingInternalServiceNoteKind }

class function TUIIncomingInternalServiceNoteKind.InternalDocumentKind: TUIInternalDocumentKindClass;
begin

  Result := TUIInternalServiceNoteKind;
  
end;

{ TUIApproveableDocumentKind }

class function TUIApproveableDocumentKind.OutcomingDocumentKind: TUIOutcomingDocumentKindClass;
begin

  Result := TUIOutcomingDocumentKind;

end;

{ TUIApproveableServiceNoteKind }

class function TUIApproveableServiceNoteKind.OutcomingDocumentKind: TUIOutcomingDocumentKindClass;
begin

  Result := TUIOutcomingServiceNoteKind;
  
end;

end.
