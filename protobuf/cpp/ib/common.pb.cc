// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ib/common.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "ib/common.pb.h"

#include <algorithm>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format.h>
// @@protoc_insertion_point(includes)

namespace ib {

namespace {

const ::google::protobuf::Descriptor* WireMessage_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  WireMessage_reflection_ = NULL;

}  // namespace


void protobuf_AssignDesc_ib_2fcommon_2eproto() {
  protobuf_AddDesc_ib_2fcommon_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "ib/common.proto");
  GOOGLE_CHECK(file != NULL);
  WireMessage_descriptor_ = file->message_type(0);
  static const int WireMessage_offsets_[2] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(WireMessage, type_name_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(WireMessage, message_data_),
  };
  WireMessage_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      WireMessage_descriptor_,
      WireMessage::default_instance_,
      WireMessage_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(WireMessage, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(WireMessage, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(WireMessage));
}

namespace {

GOOGLE_PROTOBUF_DECLARE_ONCE(protobuf_AssignDescriptors_once_);
inline void protobuf_AssignDescriptorsOnce() {
  ::google::protobuf::GoogleOnceInit(&protobuf_AssignDescriptors_once_,
                 &protobuf_AssignDesc_ib_2fcommon_2eproto);
}

void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    WireMessage_descriptor_, &WireMessage::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_ib_2fcommon_2eproto() {
  delete WireMessage::default_instance_;
  delete WireMessage_reflection_;
}

void protobuf_AddDesc_ib_2fcommon_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n\017ib/common.proto\022\002ib\"6\n\013WireMessage\022\021\n\t"
    "type_name\030\001 \002(\t\022\024\n\014message_data\030\002 \002(\014", 77);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "ib/common.proto", &protobuf_RegisterTypes);
  WireMessage::default_instance_ = new WireMessage();
  WireMessage::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_ib_2fcommon_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_ib_2fcommon_2eproto {
  StaticDescriptorInitializer_ib_2fcommon_2eproto() {
    protobuf_AddDesc_ib_2fcommon_2eproto();
  }
} static_descriptor_initializer_ib_2fcommon_2eproto_;

// ===================================================================

#ifndef _MSC_VER
const int WireMessage::kTypeNameFieldNumber;
const int WireMessage::kMessageDataFieldNumber;
#endif  // !_MSC_VER

WireMessage::WireMessage()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void WireMessage::InitAsDefaultInstance() {
}

WireMessage::WireMessage(const WireMessage& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void WireMessage::SharedCtor() {
  _cached_size_ = 0;
  type_name_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  message_data_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

WireMessage::~WireMessage() {
  SharedDtor();
}

void WireMessage::SharedDtor() {
  if (type_name_ != &::google::protobuf::internal::kEmptyString) {
    delete type_name_;
  }
  if (message_data_ != &::google::protobuf::internal::kEmptyString) {
    delete message_data_;
  }
  if (this != default_instance_) {
  }
}

void WireMessage::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* WireMessage::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return WireMessage_descriptor_;
}

const WireMessage& WireMessage::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_ib_2fcommon_2eproto();
  return *default_instance_;
}

WireMessage* WireMessage::default_instance_ = NULL;

WireMessage* WireMessage::New() const {
  return new WireMessage;
}

void WireMessage::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (has_type_name()) {
      if (type_name_ != &::google::protobuf::internal::kEmptyString) {
        type_name_->clear();
      }
    }
    if (has_message_data()) {
      if (message_data_ != &::google::protobuf::internal::kEmptyString) {
        message_data_->clear();
      }
    }
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool WireMessage::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // required string type_name = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_type_name()));
          ::google::protobuf::internal::WireFormat::VerifyUTF8String(
            this->type_name().data(), this->type_name().length(),
            ::google::protobuf::internal::WireFormat::PARSE);
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(18)) goto parse_message_data;
        break;
      }

      // required bytes message_data = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_message_data:
          DO_(::google::protobuf::internal::WireFormatLite::ReadBytes(
                input, this->mutable_message_data()));
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void WireMessage::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // required string type_name = 1;
  if (has_type_name()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->type_name().data(), this->type_name().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      1, this->type_name(), output);
  }

  // required bytes message_data = 2;
  if (has_message_data()) {
    ::google::protobuf::internal::WireFormatLite::WriteBytes(
      2, this->message_data(), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* WireMessage::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // required string type_name = 1;
  if (has_type_name()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->type_name().data(), this->type_name().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        1, this->type_name(), target);
  }

  // required bytes message_data = 2;
  if (has_message_data()) {
    target =
      ::google::protobuf::internal::WireFormatLite::WriteBytesToArray(
        2, this->message_data(), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int WireMessage::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // required string type_name = 1;
    if (has_type_name()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::StringSize(
          this->type_name());
    }

    // required bytes message_data = 2;
    if (has_message_data()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::BytesSize(
          this->message_data());
    }

  }
  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void WireMessage::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const WireMessage* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const WireMessage*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void WireMessage::MergeFrom(const WireMessage& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_type_name()) {
      set_type_name(from.type_name());
    }
    if (from.has_message_data()) {
      set_message_data(from.message_data());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void WireMessage::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void WireMessage::CopyFrom(const WireMessage& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool WireMessage::IsInitialized() const {
  if ((_has_bits_[0] & 0x00000003) != 0x00000003) return false;

  return true;
}

void WireMessage::Swap(WireMessage* other) {
  if (other != this) {
    std::swap(type_name_, other->type_name_);
    std::swap(message_data_, other->message_data_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata WireMessage::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = WireMessage_descriptor_;
  metadata.reflection = WireMessage_reflection_;
  return metadata;
}


// @@protoc_insertion_point(namespace_scope)

}  // namespace ib

// @@protoc_insertion_point(global_scope)