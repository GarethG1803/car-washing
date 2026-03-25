import { Entity, Column, ManyToOne } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';
import { User } from '../../users/entities/user.entity';
import { Vehicle } from '../../vehicles/entities/vehicle.entity';

export enum BookingStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}

@Entity('bookings')
export class Booking extends BaseEntity {
  @ManyToOne(() => User, user => user.bookings, { eager: true })
  customer: User;

  @Column()
  customerId: string;

  @ManyToOne(() => User, user => user.washerBookings, { nullable: true, eager: true })
  washer: User;

  @Column({ nullable: true })
  washerId: string;

  @ManyToOne(() => Vehicle, vehicle => vehicle.bookings, { eager: true })
  vehicle: Vehicle;

  @Column()
  vehicleId: string;

  @Column({ type: 'simple-json' })
  services: { id: string; name: string; price: number }[];

  @Column({ type: 'simple-json', nullable: true })
  addOns: { id: string; name: string; price: number }[];

  @Column({ type: 'text', default: BookingStatus.PENDING })
  status: BookingStatus;

  @Column()
  scheduledDate: Date;

  @Column()
  timeSlot: string;

  @Column()
  address: string;

  @Column({ nullable: true })
  latitude: number;

  @Column({ nullable: true })
  longitude: number;

  @Column({ type: 'float' })
  totalAmount: number;

  @Column({ type: 'float', default: 0 })
  tip: number;

  @Column({ nullable: true })
  notes: string;

  @Column({ nullable: true })
  completedAt: Date;

  @Column({ nullable: true })
  cancelledAt: Date;

  @Column({ nullable: true })
  cancellationReason: string;
}
